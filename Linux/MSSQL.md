Особенности установки MSSQL Server на Ubuntu 24.04
==================================================

Microsoft SQL Server официально не поддерживает Ubuntu 24.04, так как текущая версия (до версии 2025 включительно) поддерживает только Ubuntu 20.04 и 22.04. 
Тем не менее, можно установить SQL Server 2025- на Ubuntu 24.04, используя репозиторий для Ubuntu 22.04 и решив проблему с зависимостями вручную. 

SQL Server требует библиотеку libldap-2.5-0, которая отсутствует в Ubuntu 24.04. Скачайте и установите её из Debian Repository:

	wget http://debian.mirror.ac.za/debian/pool/main/o/openldap/libldap-2.5-0_2.5.13+dfsg-5_amd64.deb
	sudo dpkg -i libldap-2.5-0_2.5.13+dfsg-5_amd64.deb