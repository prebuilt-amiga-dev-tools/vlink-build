Param (
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$GITHUB_ORGANIZATION_NAME,
    [Parameter(Mandatory=$True)][string]$VLINK_VERSION
)

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
$InstallerProcess = Start-Process -ErrorAction Stop -Wait -NoNewWindow -PassThru msiexec -ArgumentList "/i","${BUILD_RESULTS_DIR}\\vlink-${VLINK_VERSION}-windows-installer.msi","/quiet"; if ($InstallerProcess.ExitCode -ne 0) { throw "Installation failed, exit code: $($InstallerProcess.ExitCode)" }
# Hack: add %ProgramFiles%\${GITHUB_ORGANIZATION_NAME}\vlink to path in case it is not already present
# The installer will add the folder to the path, but the current shell's path will not get updated
# Therefore we update the current shell's path manually 
if (!($Env:Path -like "${Env:ProgramFiles}\${GITHUB_ORGANIZATION_NAME}\vlink"))
{
    $Env:Path += ";${Env:ProgramFiles}\${GITHUB_ORGANIZATION_NAME}\vlink"
}

& vlink.exe -bamigahunk -o "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe" "tests/test_amigahunk.o"; if ($LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash "tests/test_amigahunk.exe.expected").hash) -ne ((Get-FileHash "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe").hash)) { throw 'vlink output does not match reference' }
if (!(Test-Path "${Env:ProgramFiles}/${GITHUB_ORGANIZATION_NAME}/vlink/vlink.pdf")) { throw "vlink.pdf is not present in installation folder" }

$UninstallerProcess = Start-Process -ErrorAction Stop -Wait -NoNewWindow -PassThru msiexec -ArgumentList "/x","${BUILD_RESULTS_DIR}\\vlink-${VLINK_VERSION}-windows-installer.msi","/quiet";  if ($UninstallerProcess.ExitCode -ne 0) { throw "Uninstallation failed, exit code: $($UninstallerProcess.ExitCode)" }
Remove-Item -ErrorAction Stop -Force -Recurse ${BUILD_RESULTS_DIR}/temp
