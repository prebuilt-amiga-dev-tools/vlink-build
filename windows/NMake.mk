
# Windows build script

!INCLUDE Config.mk

!IF "$(BUILD_TYPE)" == "RELEASE"
VLINK_URL = "$(VLINK_RELEASE_URL)"
VLINK_VERSION = "$(VLINK_RELEASE_VERSION)"
!MESSAGE RELEASE path used
!ELSEIF "$(BUILD_TYPE)" == "NIGHTLY" || !DEFINED(BUILD_TYPE)
VLINK_URL = "$(VLINK_NIGHTLY_URL)"
# It would be nice if we could have VLINK_VERSION = "0.0.0" for nightly builds.
# However, the .deb packaging flow does not have access to BUILD_TYPE or any local
#  variables from Make.mk. Therefore, we use VLINK_RELEASE_VERSION to keep
#  the versioning consistent.
VLINK_VERSION = "$(VLINK_RELEASE_VERSION)"
!MESSAGE NIGHTLY path used
!ELSE 
!MESSAGE BUILD_TYPE must be undefined, or set to NIGHTLY or RELEASE
!ENDIF

VLINKDIR=vlink

BUILD_RESULTS_DIR = build_results

GITHUB_ORGANIZATION_NAME = prebuilt-amiga-dev-tools

default: clean download build package test-packages

package: package-binaries package-wix package-choco

test-packages: test-binaries test-wix test-choco

.PHONY: clean download build package test-package
.PHONY: package-binaries package-wix package-choco
.PHONY: test-binaries test-wix test-choco

clean:
	powershell -File windows/scripts/clean.ps1 -VLINKDIR "$(VLINKDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)"

download:
	powershell windows/scripts/download.ps1 -VLINK_URL "$(VLINK_URL)" -VLINK_DOC_URL "$(VLINK_DOC_URL)"

build:
	powershell windows/scripts/build.ps1 -VLINKDIR "$(VLINKDIR)"

package-binaries:
	powershell windows/scripts/package-binaries.ps1 -VLINKDIR "$(VLINKDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VLINK_VERSION "$(VLINK_VERSION)"

package-wix:
	powershell windows/scripts/package-wix.ps1 -VLINKDIR "$(VLINKDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -GITHUB_ORGANIZATION_NAME "$(GITHUB_ORGANIZATION_NAME)" -VLINK_VERSION "$(VLINK_VERSION)"

package-choco:
	powershell windows/scripts/package-choco.ps1 -VLINKDIR "$(VLINKDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -GITHUB_ORGANIZATION_NAME "$(GITHUB_ORGANIZATION_NAME)" -VLINK_VERSION "$(VLINK_VERSION)"

test-binaries:
	powershell windows/scripts/test-binaries.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VLINK_VERSION "$(VLINK_VERSION)"

test-wix:
	powershell windows/scripts/test-wix.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -GITHUB_ORGANIZATION_NAME "$(GITHUB_ORGANIZATION_NAME)" -VLINK_VERSION "$(VLINK_VERSION)"

test-choco:
	powershell windows/scripts/test-choco.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VLINK_VERSION "$(VLINK_VERSION)"
