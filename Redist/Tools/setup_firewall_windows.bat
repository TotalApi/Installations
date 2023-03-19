SET TotalApi_Ports=1202,1237  
SET Device_Ports=8220-8229

:213.194.126.135 - Turkey IP (Emerald Paradise)
:213.155.24.83   - Ukrainian IP (Work)
:217.147.172.200 - test
:85.198.142.206  - office
:77.123.128.188  - vetal
@set ALLOWED=^
213.194.126.135,^
213.155.24.83,^
217.147.172.200,^
85.198.142.206,^
77.123.128.188


::::: Disable all existing rules for the Remote Files And Printers Access ports :::::
netsh advfirewall firewall set rule name=all protocol=tcp localport=137-139,445 new enable=no

::::: Disable all existing rules for the TotalApi Devices ports :::::
netsh advfirewall firewall set rule name=all protocol=tcp localport=%Device_Ports% new enable=no
netsh advfirewall firewall set rule name=all protocol=tcp localport=%TotalApi_Ports% new enable=no

::::: Disable all existing rules for the RDP/MSSQL ports :::::
netsh advfirewall firewall set rule name=all protocol=tcp localport=3389 new enable=no
netsh advfirewall firewall set rule name=all protocol=udp localport=3389 new enable=no
netsh advfirewall firewall set rule name=all protocol=tcp localport=1433 new enable=no



::::: Remove all the rules with the names :::::
netsh advfirewall firewall delete rule name="!TotalApi.Devices"
netsh advfirewall firewall delete rule name="!TotalApi.Services"
netsh advfirewall firewall delete rule name="!RDP.TCP"
netsh advfirewall firewall delete rule name="!RDP.UDP"
netsh advfirewall firewall delete rule name="!MSSQL"
netsh advfirewall firewall delete rule name="!All"


:::: Add rule for accept income data for TotalApi Devices ::::
netsh advfirewall firewall add rule name="!TotalApi.Devices" dir=in action=allow protocol=tcp localport=%Device_Ports%



:::: Add rule for accept income data for RDP/MSSQL/TotalApi connections ::::
:netsh advfirewall firewall add rule name="!All" dir=in action=allow protocol=all remoteip=%ALLOWED%

netsh advfirewall firewall add rule name="!TotalApi.Services" localport=%TotalApi_Ports% dir=in action=allow protocol=tcp remoteip=%ALLOWED%
netsh advfirewall firewall add rule name="!RDP.TCP"           localport=3389             dir=in action=allow protocol=tcp remoteip=%ALLOWED%
netsh advfirewall firewall add rule name="!RDP.UDP"           localport=3389             dir=in action=allow protocol=udp remoteip=%ALLOWED%
netsh advfirewall firewall add rule name="!MSSQL"             localport=1433             dir=in action=allow protocol=tcp remoteip=%ALLOWED%
