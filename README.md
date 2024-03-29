[Инструкция по установке программного комплекса Metrix](https://github.com/TotalApi/Installations/blob/main/README.md) 
=======================================================================================================================



Состав установки
----------------

1. База данных хранения телематических данных [Apache Cassandra](https://cassandra.apache.org/)
   - [Инструкция по установке на Ubuntu](Cassandra/Cassandra.md)

2. На операционной системе Windows установить необходимые инструменты, указанные [на этой странице](Redist/Readme.md).

3. Сервис работы с телематическими данными **TotalApi**
   - Распаковать содержимое [архива](https://github.com/TotalApi/Installations/raw/main/Redist/totalapi-latest.zip) в любую папку;
   - Скопировать образцы [конфигурационных файлов](https://github.com/TotalApi/Installations/raw/main/Configs/Default/TotalApi) в папку **TotalApi**;
   - Настроить сервис в [конфигурационном файле](Configs/TotalApi_Config.md);
   - Настроить [модули приёма координат](Configs/TotalApi_DevicePlugins.md);
   - Установить сервис как службу Windows, выполнив команду в командной строке `TotalApi.Server.Host.exe /i`  с правами администратора.

4. База данных для Web-приложения **Metrix**
   - установить БД MS SQL Server 2012 R2 x64 или выше. (Использование других редакций теоретически возможно, но не проверялось);
   - (опционально) установить [SQL Server Management Studio](https://aka.ms/ssmsfullsetup).
 
5. Web-приложение **Metrix**
   - Установить на сервере IIS 7+ (при установке обязательно выбрать опцию поддержки Web-socket);
   - Для автоматического старта приложения выполнить рекомендации, описанные [здесь](https://www.taithienbo.com/how-to-auto-start-and-keep-an-asp-net-core-web-application-and-keep-it-running-on-iis/) и [здесь](https://docs.hangfire.io/en/latest/deployment-to-production/making-aspnet-app-always-running.html);
   - Распаковать содержимое [архива](https://github.com/TotalApi/Installations/raw/main/Redist/MetrixWeb-latest.zip) в любую папку;
   - Скопировать образцы [конфигурационных файлов](https://github.com/TotalApi/Installations/raw/main/Configs/Default/MetriX) в папку **Metrix**;
   - Настроить сервис в [конфигурационном файле](Configs/Metrix_Config.md);
   - Создать в IIS Web-приложение, указав папку **Metrix** в качестве корневой; 

