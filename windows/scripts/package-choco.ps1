Param (
    [Parameter(Mandatory=$True)][string]$VLINKDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$GITHUB_ORGANIZATION_NAME,
    [Parameter(Mandatory=$True)][string]$VLINK_VERSION
)

$VLINK_PACKAGE_VERSION = & windows/scripts/get-package-version.ps1 -VLINK_VERSION $VLINK_VERSION

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}"

if (Test-Path windows/choco/bin)
{
    Remove-Item -ErrorAction Stop -Force -Recurse windows/choco/bin
}
mkdir -ErrorAction Stop -Force windows/choco/bin
Copy-Item -ErrorAction Stop "${VLINKDIR}/vlink.exe" windows/choco/bin/vlink.exe
& choco.exe pack windows/choco/vlink.nuspec --out "${BUILD_RESULTS_DIR}" --properties "version=${VLINK_PACKAGE_VERSION}" "github_organization_name=${GITHUB_ORGANIZATION_NAME}"; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop -Force -Recurse windows/choco/bin
