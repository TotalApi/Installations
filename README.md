[Инструкция по установке программного комплекса Metrix](https://github.com/TotalApi/Installations/blob/main/README.md) 
=======================================================================================================================

Состав установки
----------------
Работа возможна как на серверах Linux (Ubuntu), так и на серверах Windows.

1. База данных хранения телематических данных [Apache Cassandra](https://cassandra.apache.org/) / [ScyllaDB](https://www.scylladb.com/)
   - [Инструкция по установке **Apache Cassandra** на Ubuntu](Cassandra/Cassandra.md)
   - [Инструкция по установке **Apache Cassandra** на Windows](https://phoenixnap.com/kb/install-cassandra-on-windows)
   - [Инструкция по установке **ScyllaDB** на Ubuntu](ScyllaDb/ScyllaDb.md)

2. На операционной системе Windows установить необходимые инструменты, указанные [на этой странице](Redist/Readme.md).

3. Сервис работы с телематическими данными **TotalApi** (установка на **Windows**)
   - Распаковать содержимое [архива](https://github.com/TotalApi/Installations/raw/main/Redist/totalapi-win-x64-latest.zip) в любую папку;
   - Скопировать образцы [конфигурационных файлов](Configs/Default/TotalApi/README.md) в папку **TotalApi**;
   - Настроить сервис в [конфигурационном файле](Configs/TotalApi_Config.md);
   - Настроить [модули приёма координат](Configs/TotalApi_DevicePlugins.md);
   - Установить сервис как службу Windows, выполнив команду в командной строке `TotalApi.Server.Host.exe /i`  с правами администратора.

4. База данных **MSSQL Server** для Web-приложения **Metrix**
   - установить БД **MSSQL Server 2012 R2 x64** или выше. (Использование других редакций теоретически возможно, но не проверялось);
   - (опционально) установить **[SQL Server Management Studio](https://aka.ms/ssmsfullsetup)**.
 
5. База данных **PostreSQL** для Web-приложения **Metrix**
   - установить БД **[PostreSQL v17.5](https://www.postgresql.org/download/)** или выше. (Использование других редакций теоретически возможно, но не проверялось);
   - (опционально) установить **[PgAdmin v4](https://www.pgadmin.org/download/)**.

5. Web-приложение **Metrix** (установка на **Windows**)
   - Установить на сервере IIS 7+ (при установке обязательно выбрать опцию поддержки Web-socket);
   - Для автоматического старта приложения выполнить рекомендации, описанные [здесь](https://www.taithienbo.com/how-to-auto-start-and-keep-an-asp-net-core-web-application-and-keep-it-running-on-iis/) и [здесь](https://docs.hangfire.io/en/latest/deployment-to-production/making-aspnet-app-always-running.html);
   - Распаковать содержимое [архива](https://github.com/TotalApi/Installations/raw/main/Redist/MetrixWeb-win-x64-latest.zip) в любую папку;
   - Скопировать образцы [конфигурационных файлов](https://github.com/TotalApi/Installations/raw/main/Configs/Default/MetriX) в папку **Metrix**;
   - Настроить сервис в [конфигурационном файле](Configs/Metrix_Config.md);
   - Создать в IIS Web-приложение, указав папку **Metrix** в качестве корневой; 


[Решение проблем при нештатных ситуациях работы программного комплекса](TroubleShooting.md)
-------------------------------------------------------------------------------------------
Подробности описаны в [данной статье](TroubleShooting.md).