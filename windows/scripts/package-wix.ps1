Param (
    [Parameter(Mandatory=$True)][string]$VLINKDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$GITHUB_ORGANIZATION_NAME,
    [Parameter(Mandatory=$True)][string]$VLINK_VERSION
)

$VLINK_PACKAGE_VERSION = & windows/scripts/get-package-version.ps1 -VLINK_VERSION $VLINK_VERSION

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
Copy-Item -ErrorAction Stop ${VLINKDIR}/vlink.exe "${BUILD_RESULTS_DIR}/temp/vlink.exe"
Copy-Item -ErrorAction Stop ${VLINKDIR}/vlink.pdf "${BUILD_RESULTS_DIR}/temp/vlink.pdf"
& candle.exe windows/wix/vlink.wxs -o "${BUILD_RESULTS_DIR}/temp/vlink.wixobj" -arch x64 "-dApplicationVersion=${VLINK_PACKAGE_VERSION}" "-dGithubOrganizationName=${GITHUB_ORGANIZATION_NAME}"; if ($LASTEXITCODE -ne 0) { throw }
& light.exe "${BUILD_RESULTS_DIR}/temp/vlink.wixobj" -o "${BUILD_RESULTS_DIR}/vlink-${VLINK_VERSION}-windows-installer.msi" -ext WixUIExtension -loc windows/wix/vlink.wxl -sice:ICE61; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/vlink-${VLINK_VERSION}-windows-installer.wixpdb"
