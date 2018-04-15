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

package polarion_xml

const (
	CaseImportance = "Importance"
	CasePosNeg     = "Positive"
)

const (
	IdImportance = "caseimportance"
	IdPosNeg     = "caseposneg"
)

const (
	ImportanceCritical = "ImportanceCritical"
	ImportanceHigh     = "ImportanceHigh"
	ImportanceMedium   = "ImportanceMedium"
	ImportanceLow      = "ImportanceLow"
)

const (
	CasePositive = "CasePositive"
	CaseNegative = "CaseNegative"
)

var FieldsIds = map[string]string {
	CaseImportance: IdImportance,
	CasePosNeg    : IdPosNeg,
}

var FieldsValues = map[string]string {
	ImportanceCritical: "critical",
	ImportanceHigh: "high",
	ImportanceMedium: "medium",
	ImportanceLow: "low",
	CasePositive: "positive",
	CaseNegative: "negative",
}

func Importance(content string) {
}

func Positive(content string) {
}
