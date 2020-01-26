
# Unix build script

include Config.mk

# DISTRIBUTION defaults to unknown

ifeq ($(strip $(DISTRIBUTION)),)
DISTRIBUTION := unknown
endif

# BUILD_TYPE defaults to NIGHTLY

ifeq ($(strip $(BUILD_TYPE)),)
BUILD_TYPE := NIGHTLY
endif

# Setup VLINK_URL and VLINK_VERSION to refer to either the release or nightly build

ifeq ($(strip $(BUILD_TYPE)),RELEASE)
VLINK_URL := $(VLINK_RELEASE_URL)
VLINK_VERSION := $(VLINK_RELEASE_VERSION)
else ifeq ($(strip $(BUILD_TYPE)),NIGHTLY)
VLINK_URL := $(VLINK_NIGHTLY_URL)
# It would be nice if we could have VLINK_VERSION = "0.0.0" for nightly builds.
# However, the .deb packaging flow does not have access to BUILD_TYPE or any local
#  variables from Make.mk. Therefore, we use VLINK_RELEASE_VERSION to keep
#  the versioning consistent.
VLINK_VERSION := $(VLINK_RELEASE_VERSION)
else
$(error BUILD_TYPE must be undefined, or set to NIGHTLY or RELEASE)
endif

BUILD_RESULTS_DIR = build_results

.PHONY: clean download build package-deb test-deb update-homebrew-formula-locally test-homebrew-formula

default: clean download build package-deb test-deb update-homebrew-formula-locally test-homebrew-formula

.PHONY: install-deb uninstall-deb extract-changelog release

######################################################################################
# These build steps are intended to be invoked manually with make

clean:
	./linux/scripts/clean.sh "$(BUILD_RESULTS_DIR)"

download:
	./linux/scripts/download.sh "$(VLINK_URL)" "$(VLINK_DOC_URL)"

build:
	./linux/scripts/build.sh

package-deb:
	./linux/scripts/package-deb.sh "$(BUILD_RESULTS_DIR)" "$(VLINK_VERSION)" "$(DISTRIBUTION)"

test-deb:
	./linux/scripts/test-deb.sh "$(BUILD_RESULTS_DIR)" "$(VLINK_VERSION)" "$(DISTRIBUTION)"

extract-changelog:
	./linux/scripts/extract-changelog.sh "$(BUILD_RESULTS_DIR)" "$(VLINK_VERSION)"

######################################################################################
# These build steps are not part of the build/package process; they allow for
# easy local testing of a newly-built .deb package

install-deb:
	./linux/scripts/install-deb.sh "$(BUILD_RESULTS_DIR)" "$(VLINK_VERSION)" "$(DISTRIBUTION)"

uninstall-deb:
	./linux/scripts/uninstall-deb.sh

######################################################################################
# These steps are part of the automated release process; they modify
#  the Git repository and push to origin

update-config:
	./linux/scripts/update-config.sh "${NEW_VLINK_RELEASE_URL}" "$(NEW_VLINK_RELEASE_VERSION)"

release:
	./linux/scripts/release.sh "$(VLINK_VERSION)"

######################################################################################

include homebrew/Make.mk
