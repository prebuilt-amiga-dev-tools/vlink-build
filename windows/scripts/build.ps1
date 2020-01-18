Param (
    [Parameter(Mandatory=$True)][string]$VLINKDIR
)

mkdir -ErrorAction Stop -Force "${VLINKDIR}/obj_win32"
Push-Location -ErrorAction Stop "${VLINKDIR}"
try {
    & nmake /F makefile.Win32; if ($LASTEXITCODE -ne 0) { throw }
} finally {
    Pop-Location
}
