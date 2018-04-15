/*
 * This file is part of the KubeVirt project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2018 Red Hat, Inc.
 *
 */

package main

import (
	"fmt"
	"flag"
	"go/ast"
	"go/parser"
	"go/token"
	"path/filepath"
	"os"
	"strings"

	"kubevirt.io/qe-tools/polarion-xml"
)

const (
	ginkgoDescribe = "Describe"
	ginkgoContext = "Context"
	ginkgoSpecify = "Specify"
	ginkgoWhen = "When"
	ginkgoBy = "By"
	ginkgoIt = "It"
)

type ginkgoBlock struct {
	content     []string
	rparenPos   []token.Pos
	steps       []string
	stepContext []token.Pos
	inIt        bool
}

func addCustomField(customFields *polarion_xml.TestCaseCustomFields, id, content string) {
	customFields.CustomFields = append(
		customFields.CustomFields, polarion_xml.TestCaseCustomField{
			Content: content,
			ID:      id,
		})
}

func addTestStep(testCaseSteps *polarion_xml.TestCaseSteps, content string, prepend bool) {
	testCaseStep := polarion_xml.TestCaseStep{
		StepColumn: []polarion_xml.TestCaseStepColumn{
			{
				Content: content,
				ID: "step",
			},
			{
				Content: "Succeeded",
				ID: "expectedResult",
			},
		},
	}
	if prepend {
		testCaseSteps.Steps = append([]polarion_xml.TestCaseStep{testCaseStep}, testCaseSteps.Steps...)
	} else {
		testCaseSteps.Steps = append(testCaseSteps.Steps, testCaseStep)
	}
}

func fillPolarionTestCases(file string, testCases *polarion_xml.TestCases) {
	// Create the AST by parsing src.
	fset := token.NewFileSet() // positions are relative to fset
	f, err := parser.ParseFile(fset, file, nil, 0)
	if err != nil {
		panic(err)
	}

	var block *ginkgoBlock

	ast.Inspect(f, func(n ast.Node) bool {
		switch x := n.(type) {
		case *ast.CallExpr:
			var ident *ast.Ident
			if v, ok := x.Fun.(*ast.Ident); ok {
				ident = v
			} else if v, ok := x.Fun.(*ast.SelectorExpr); ok {
				ident = v.Sel
			} else {
				return false
			}

			if len(x.Args) < 1 {
				return true
			}

			var content string
			if v, ok := x.Args[0].(*ast.BasicLit); ok {
				content = v.Value
			} else if v, ok := x.Args[0].(*ast.SelectorExpr); ok {
				content = v.Sel.Name
			} else {
				return true
			}
			value := strings.Trim(content, "\"")

			switch ident.Name {
			case ginkgoDescribe, ginkgoContext, ginkgoWhen:
				if block == nil {
					block = &ginkgoBlock{
						content:   []string{value},
						rparenPos: []token.Pos{x.Rparen},
					}
				} else {
					for i := len(block.rparenPos) - 1; i >= 0; i-- {
						if block.rparenPos[i] > x.Rparen {
							block.rparenPos = append(block.rparenPos, x.Rparen)
							block.content = append(block.content, value)
							break
						} else {
							block.rparenPos = block.rparenPos[:len(block.rparenPos)-1]
							block.content = block.content[:len(block.content)-1]
						}
					}
				}
				block.inIt = false
			case ginkgoBy:
				if block.inIt {
					testCase := &testCases.TestCases[len(testCases.TestCases) - 1]
					addTestStep(&testCase.TestCaseSteps, value, false)
				} else {
					block.steps = append(block.steps, value)
					block.stepContext = append(block.stepContext, block.rparenPos[len(block.rparenPos) - 1])
				}
			case ginkgoIt, ginkgoSpecify:
				for i := len(block.rparenPos) - 1; i >= 0; i-- {
					if block.rparenPos[i] > x.Rparen {
						break
					} else {
						block.rparenPos = block.rparenPos[:len(block.rparenPos)-1]
						block.content = block.content[:len(block.content)-1]
					}
				}
				title := fmt.Sprintf("%s: %s %s", block.content[0], strings.Join(block.content[1:], " "), value)
				customFields := polarion_xml.TestCaseCustomFields{}
				addCustomField(&customFields, "caseautomation", "automated")
				addCustomField(&customFields, "testtype", "functional")
				addCustomField(&customFields, "upstream", "yes")
				testCase := polarion_xml.TestCase{
					Title: polarion_xml.Title{Content: title},
					Description: polarion_xml.Description{Content: title},
					TestCaseCustomFields: customFields,
				}

				for i := len(block.stepContext) - 1; i >= 0; i-- {
					if block.stepContext[i] > x.Rparen {
						addTestStep(&testCase.TestCaseSteps, block.steps[i], true)
					} else {
						block.steps = block.steps[:len(block.steps)-1]
						block.stepContext = block.stepContext[:len(block.stepContext)-1]
					}
				}
				testCases.TestCases = append(testCases.TestCases, testCase)
				block.inIt = true
			case polarion_xml.CaseImportance, polarion_xml.CasePosNeg:
				addCustomField(
					&testCases.TestCases[len(testCases.TestCases) - 1].TestCaseCustomFields,
					polarion_xml.FieldsIds[ident.Name],
					polarion_xml.FieldsValues[value],
				)
			}
		}
		return true
	})
}

func main() {
	// parse input flags
	testsDir := flag.String("tests-dir", ".", "Directory with tests files")
	outputFile := flag.String("output-file", "polarion.xml", "Generated polarion test cases")
	polarionProjectId := flag.String("project-id", "", "Set the Polarion project ID")
	flag.Parse()

	// collect all test files from the directory
	var files []string
	err := filepath.Walk(*testsDir, func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			return nil
		}

		if !strings.Contains(info.Name(), "_test") {
			return nil
		}
		files = append(files, path)
		return nil
	})
	if err != nil {
		panic(err)
	}

	// parse all test files and fill polarion test cases
	var testCases = &polarion_xml.TestCases{ProjectID: *polarionProjectId}
	for _, file := range files {
		fillPolarionTestCases(file, testCases)
	}

	// generate polarion test cases XML file
	polarion_xml.GeneratePolarionXmlFile(*outputFile, testCases)
}
