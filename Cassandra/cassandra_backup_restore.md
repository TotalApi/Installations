Создание резервной копии
========================

[Статья 1](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/operations/opsBackupTakesSnapshot.html)
[Статья 2](https://docs.axway.com/bundle/axway-open-docs/page/docs/cass_admin/cassandra_bur/index.html)
[Статья 3](https://community.datastax.com/questions/4818/backup-and-restore-cassandra-keyspace.html)
[Статья 4](https://cassandra.apache.org/doc/latest/operating/backups.html)


Все операции можно проводить на удалённом компютере. В этом случае следует указать параметры подключения: `<host>` и `<JMX-port>`

`nodetool -h <host> -p <JMX-port-7199> <command> <args>`


На основании снимков (snapshots)
--------------------------------
Предварительно следует отключить автоматическое создание снимков перед обрезкой таблиц или изменения их структуры.
В файле `\conf\cassandra.yaml` следует установить опцию

    auto_snapshot: false


Предварительная очистка неверных реплик перед созданием снимка:

    nodetool cleanup <keyspace>

Создание полного снапшота с указанным именем:

    nodetool snapshot <keyspace> --tag <snapshot_name>


Снимок будет создан для каждой из таблиц в папках `data_directory/<keyspace>/<table_name-UUID>/snapshots/<snapshot_name>`.
Если имя снимка не указывать - будет взято текущее время в UNIX-формате.
Повторно сделать снимок с тем же именем нельзя.


Удаление снимка

    nodetool clearsnapshot <keyspace> -t <snapshot_name>


Восстановление из резервной копии
=================================

1. Остановить Cassandra:

        nodetool stopdaemon

2. В `CASSANDRA_DATA_DIRECTORY` удалить папки `commitlog` и `saved_caches`:

        rm -r /opt/cassandra/data/commitlog/* /opt/cassandra/data/saved_caches/*


3. В `CASSANDRA_DATA_DIRECTORY` в каталоге `%KEYSPACE%\%TABLE%-<UID>` удалить все файлы и каталоги:

        rm -rf /opt/cassandra/data/data/%KEYSPACE%/%TABLE%-<UID>/*


4. Скопировать все файлы и каталоги таблицы из соответствующего каталога резервной копии в каталог `%KEYSPACE%\%TABLE%-<UID>`.
  
5. Повторить, начиная с пункта 3, для остальных таблиц.

6. Запустить Cassandra и дождаться окончания загрузки:


        sudo systemctl start cassandra
        
        nodetool status



Восстановление из резервной копии без остановки Cassandra
=========================================================

1. Выполнить обрезку восстанавливаемой таблицы:

        ccqlsh> truncate %KEYSPACE%.%TABLE%

2. Скопировать все файлы и каталоги таблицы из соответствующего каталога резервной копии в соответствующий каталог `KEYSPACE`.

3. Применить сделанные изменения:
        
        nodetool refresh %KEYSPACE% %TABLE%

        nodetool refresh test_metadata device
        nodetool refresh test_metadata devicestatus
        nodetool refresh test_metadata sensor
        nodetool refresh test_metadata sensorstatus
        nodetool refresh test_metadata systemdata


4. Повторить, начиная с пункта 1, для остальных таблиц.


Действия после восстановления
=============================

1. Обновить таблицы до последней версии

        nodetool upgradesstables [%KEYSPACE%] [%TABLE%]

        nodetool upgradesstables test_metadata
        nodetool upgradesstables test

2. Перестроить индексы

        nodetool rebuild_index %KEYSPACE% %TABLE% %INDEX_NAME%

        nodetool rebuild_index test_metadata device device_apikey_idx
        nodetool rebuild_index test_metadata device device_imei_idx
        nodetool rebuild_index test_metadata device device_mac_idx
        nodetool rebuild_index test_metadata device device_own_id_idx
        nodetool rebuild_index test_metadata device device_phone_idx
        nodetool rebuild_index test_metadata device device_userid_idx

        nodetool rebuild_index test_metadata sensor sensor_apikey_idx
        nodetool rebuild_index test_metadata sensor sensor_devid_idx
        nodetool rebuild_index test_metadata device sensor_userid_idx
