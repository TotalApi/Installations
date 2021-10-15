Инструкция по установке программного комплекса Metrix 
=====================================================


Состав установки
----------------

1. База данных хранения телематических данных [Apache Cassandra](https://cassandra.apache.org/)
   - [Инструкция по установке на Ubuntu](Cassandra/Cassandra.md)

2. На операционной системе Windows установить необходимые инструменты, указанные [на этой странице](Redist/Readme.md).

3. Сервис работы с телематическими данными **TotalApi**
   - Распаковать содержимое [архива](https://github.com/TotalApi/Installations/raw/main/Redist/totalapi-latest.zip) в любую папку;
   - Настроить сервис в [конфигурационном файле](Configs/TotalApi_Config.md);
   - Настроить [модули приёма координат](Configs/TotalApi_DevicePlugins.md);
   - Установить сервис как службу Windows, выполнив команду в командной строке `TotalApi.Server.Host.exe i`  с правами администратора.
 
4. Web-приложение **Metrix**

5. База данных для Web-приложения **Metrix**
