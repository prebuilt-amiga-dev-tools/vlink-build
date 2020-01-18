
Param (
    [Parameter(Mandatory=$True)][string]$VLINK_URL,
    [Parameter(Mandatory=$True)][string]$VLINK_DOC_URL
)

Invoke-WebRequest -ErrorAction Stop -Uri "${VLINK_URL}" -OutFile vlink.tar.gz
tar -xvf vlink.tar.gz; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop vlink.tar.gz
Copy-Item -ErrorAction Stop Windows/Makefile.Win32 vlink

Invoke-WebRequest -ErrorAction Stop -Uri "${VLINK_DOC_URL}" -OutFile vlink/vlink.pdf
