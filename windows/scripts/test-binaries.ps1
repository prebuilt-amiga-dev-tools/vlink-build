Param (
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$VLINK_VERSION
)

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
Expand-Archive -ErrorAction Stop -Path "${BUILD_RESULTS_DIR}/vlink-${VLINK_VERSION}-windows-binaries.zip" -DestinationPath "${BUILD_RESULTS_DIR}/temp"
& "${BUILD_RESULTS_DIR}/temp/vlink.exe" -bamigahunk -o "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe" "tests/test_amigahunk.o"; if ($LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash "tests/test_amigahunk.exe.expected").hash) -ne ((Get-FileHash "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe").hash)) { throw 'vlink output does not match reference' }
if (!(Test-Path "${BUILD_RESULTS_DIR}/temp/vlink.pdf")) { throw "vlink.pdf is not present within archive" }
if (!(Test-Path "${BUILD_RESULTS_DIR}/temp/history")) { throw "history is not present within archive" }
if (!(Test-Path "${BUILD_RESULTS_DIR}/temp/LICENSE.md")) { throw "LICENSE.md is not present within archive" }
Remove-Item -ErrorAction Stop -Force -Recurse ${BUILD_RESULTS_DIR}/temp
