package main

import (
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"testing"
)

func TestPolarionGenerator(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "PolarionGenerator Suite")
}
