Param (
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$VLINK_VERSION
)

$VLINK_PACKAGE_VERSION = & windows/scripts/get-package-version.ps1 -VLINK_VERSION $VLINK_VERSION

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
& choco install -y -s "${BUILD_RESULTS_DIR}" vlink; if ($LASTEXITCODE -ne 0) { throw }

& vlink.exe -bamigahunk -o "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe" "tests/test_amigahunk.o"; if ($LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash "tests/test_amigahunk.exe.expected").hash) -ne ((Get-FileHash "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe").hash)) { throw 'vlink output does not match reference' }

& choco uninstall vlink; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop -Force -Recurse ${BUILD_RESULTS_DIR}/temp
