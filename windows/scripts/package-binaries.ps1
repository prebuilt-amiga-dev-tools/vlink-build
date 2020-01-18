Param (
    [Parameter(Mandatory=$True)][string]$VLINKDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$VLINK_VERSION
)

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
Copy-Item -ErrorAction Stop "${VLINKDIR}/vlink.exe" "${BUILD_RESULTS_DIR}/temp/vlink.exe"
Copy-Item -ErrorAction Stop "${VLINKDIR}/vlink.pdf" "${BUILD_RESULTS_DIR}/temp/vlink.pdf"
Copy-Item -ErrorAction Stop "${VLINKDIR}/history" "${BUILD_RESULTS_DIR}/temp/history"
Copy-Item -ErrorAction Stop "LICENSE.md" "${BUILD_RESULTS_DIR}/temp/LICENSE.md"
Compress-Archive -ErrorAction Stop -Path "${BUILD_RESULTS_DIR}/temp/vlink.exe", "${BUILD_RESULTS_DIR}/temp/vlink.pdf", "${BUILD_RESULTS_DIR}/temp/history", "${BUILD_RESULTS_DIR}/temp/LICENSE.md" -DestinationPath "${BUILD_RESULTS_DIR}/vlink-${VLINK_VERSION}-windows-binaries.zip"
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
