BASE_FOLDER ?= $(shell bash -c 'pwd')	# Base repo Folder
LABS_FOLDER ?= "labs"					# Relative to the BASE_FOLDER, where the md files are located
TARGET		?= "k8s-multus-1.13.3"		# K8s taget based on Kubevirtci k8s supported versions

default: tests

build: clean
	hack/build ${LABS_FOLDER}

tests:
	hack/tests ${TARGET}

clean:
	@echo "cleaning build folder"
	@rm -rf build

.PHONY: clean tests
