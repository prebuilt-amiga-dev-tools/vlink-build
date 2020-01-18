
Param (
    [Parameter(Mandatory=$True)][string]$VLINKDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR
)

if (Test-Path ${VLINKDIR})
{
    Remove-Item -ErrorAction Stop -Recurse -Force "${VLINKDIR}"
}

if (Test-Path vlink.tar.gz)
{
    Remove-Item -ErrorAction Stop -Recurse -Force vlink.tar.gz
}

if (Test-Path ${BUILD_RESULTS_DIR})
{
    Remove-Item -ErrorAction Stop -Recurse -Force "${BUILD_RESULTS_DIR}"
}

if (Test-Path windows/choco/bin) {
    Remove-Item -ErrorAction Stop -Recurse -Force windows/choco/bin
}
