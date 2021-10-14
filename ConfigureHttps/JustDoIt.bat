%~d0
cd %~dp0
@makecert -pe -ss MY -sr LocalMachine -a sha1 -sky exchange -n CN=ClientCerttificate myCert.cer
@call BindPort.bat 443 myCert.cer 1234



