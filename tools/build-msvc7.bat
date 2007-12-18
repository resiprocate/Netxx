SET VERSION=0.4.1
SET WITH_OPENSSL=yes
START /WAIT jam.exe --release
CD src
RENAME release release-tls
CD..
CD examples
RENAME release release-tls
CD..
SET WITH_OPENSSL=no
START /WAIT jam.exe --release
CD..
START /WAIT zip.exe -r netxx-%VERSION%-win32.zip netxx-%VERSION% -x *.obj *.pdb
ECHO Done
