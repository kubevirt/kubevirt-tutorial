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

package ginkgo_reporters

import (
	"flag"
	"fmt"
	"strings"

	"kubevirt.io/qe-tools/pkg/polarion-xml"

	"github.com/onsi/ginkgo/config"
	"github.com/onsi/ginkgo/types"
)

var Polarion = PolarionReporter{}

func init() {
	flag.BoolVar(&Polarion.Run, "polarion", false, "Run Polarion reporter")
	flag.StringVar(&Polarion.projectId, "polarion-project-id", "", "Set the Polarion project ID")
	flag.StringVar(&Polarion.filename, "polarion-report-file", "polarion.xml", "Set the Polarion report file path")
}

type PolarionReporter struct {
	suite         polarion_xml.TestCases
	Run           bool
	filename      string
	projectId     string
	testSuiteName string
}

func (reporter *PolarionReporter) SpecSuiteWillBegin(config config.GinkgoConfigType, summary *types.SuiteSummary) {
	reporter.suite = polarion_xml.TestCases{
		TestCases: []polarion_xml.TestCase{},
	}
	reporter.testSuiteName = summary.SuiteDescription
}

func (reporter *PolarionReporter) SpecWillRun(specSummary *types.SpecSummary) {
}

func (reporter *PolarionReporter) BeforeSuiteDidRun(setupSummary *types.SetupSummary) {
}

func (reporter *PolarionReporter) AfterSuiteDidRun(setupSummary *types.SetupSummary) {
}

func (reporter *PolarionReporter) SpecDidComplete(specSummary *types.SpecSummary) {
	testName := fmt.Sprintf(
		"%s: %s",
		specSummary.ComponentTexts[1],
		strings.Join(specSummary.ComponentTexts[2:], " "),
	)
	testCase := polarion_xml.TestCase{
		Title:       polarion_xml.Title{Content: testName},
		Description: polarion_xml.Description{Content: testName},
	}
	customFields := polarion_xml.TestCaseCustomFields{}
	customFields.CustomFields = append(customFields.CustomFields, polarion_xml.TestCaseCustomField{
		Content: "automated",
		ID:      "caseautomation",
	})
	testCase.TestCaseCustomFields = customFields

	reporter.suite.TestCases = append(reporter.suite.TestCases, testCase)
}

func (reporter *PolarionReporter) SpecSuiteDidEnd(summary *types.SuiteSummary) {
	if reporter.projectId == "" {
		fmt.Println("Can not create Polarion report without project ID")
		return
	}
	reporter.suite.ProjectID = reporter.projectId

	// generate polarion test cases XML file
	polarion_xml.GeneratePolarionXmlFile(Polarion.filename, &Polarion.suite)
}
