[Установка Influx 1.x на Ubuntu](https://influxdata.com/downloads/)
===================================================================
[Ссылка 1](https://influxdata.com/downloads/)
[Ссылка 2](https://medium.com/yavar/install-and-setup-influxdb-on-ubuntu-20-04-22-04-3d6e090ec70c)

Последняя поддерживаемая версия `Influx 1.x` - `1.11.8-2`

Debian and Ubuntu users can install the latest stable version of InfluxDB using the apt-get package manager. For Ubuntu users, you can add the InfluxData repository configuration by using the following commands:

	wget -q https://repos.influxdata.com/influxdata-archive_compat.key
    echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null	
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list	
	
или прямое скачивание и установка дистрибутива:

    wget https://repos.influxdata.com/debian/packages/influxdb-1.11.8-2-amd64.deb
    sudo dpkg -i influxdb-1.11.8-2-amd64.deb

Старое:
    
	curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
    source /etc/lsb-release
    echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list


And then to install and start the InfluxDB service:

    sudo apt-get update && sudo apt-get install influxdb
    sudo service influxdb start

Проверить версию после установки:

    influx -version



[Фишки InfluxDb](http://docs.influxdata.com)
============================================
Для доступа к админ консоли нужно подключится к контейнеру (если в Docker'е)
    
    sudo docker exec -i -t influxdb /bin/bash

Создать конфигурационный файл (если он не существует):

    influxd config > /etc/influxdb/influxdb.conf

Просмотр протокола:

	sudo journalctl -u influxdb.service > influxdb_all.log

Просмотр последних 100 записей:

	sudo journalctl -u influxdb.service -n 100  > influxdb_last_100.log

"Живая" запись протокола в файл:

	sudo journalctl -u influxdb.service -f  > influxdb_live_tail.log

	
Чтобы сделать автоматический вывод протокола в файл необходимо скопировать файлы из каталога [tools/influxdb] в каталог `/etc/influxdb/tools` 
и запустить файл:

	sudo install_save_influxdb_logs.sh


Включить UDP
------------
В конфигурационном файле `/etc/influxdb/influxdb.conf` создать или раскомментировать следующие строки:

	[[udp]]
  		enabled = true
  		bind-address = ":4444"
  		database = "stat_db"
  		retention-policy = "seven_days"
	

Запись протокола доступа по http (только чтение данных) в файл
--------------------------------------------------------------
В конфигурационном файле `/etc/influxdb/influxdb.conf` создать или раскомментировать следующие строки:

	[http]
  		access-log-path = "/var/log/influxdb/access_http.log"


Начальная настройка БД
----------------------
Для доступа к админ консоли нужно запустить 
    
    influx

Создание новой базы

    -- stat_db - ИМЯ_БАЗЫ
    CREATE DATABASE stat_db

Создание retention policy - сколько данные будут храниться в базе

    -- stat_db - ИМЯ_БАЗЫ
    USE stat_db
    CREATE RETENTION POLICY "seven_days" ON stat_db DURATION 7d REPLICATION 1
    CREATE USER root WITH PASSWORD 'P@ssw0rd' WITH ALL PRIVILEGES

Удаление измерения - аналог таблицы (в случае если изменились типы полей в измерении, то необходимо удалять все измерение)

    DROP MEASUREMENT <ИМЯ_ИЗМЕРЕНИЯ>

Удаление данных из таблицы

    DROP SERIES FROM <ИМЯ_ИЗМЕРЕНИЯ> [WHERE ...]


[Fixing SHOW MEASUREMENTS bug](https://github.com/influxdata/influxdb/issues/4395)
----------------------------------------------------------------------------------
Если сразу после установки `show measurements` возвращает пустое множество выполните в консоле Influx:
    
    use stat_db
    show measurements
    insert foo value=12
    show measurements

После записи реальных данных это измерение можно удалить:
	
	drop measurement foo


    
[Установка Chronograf на Ubuntu](https://influxdata.com/downloads/)
===================================================================
Последняя поддерживаемая версия `Chronograf` для `Influx 1.x` - `1.10.7`

`Chronograf` нужен для отображения данных о собранной статистике.

Ubuntu & Debian 64-bit system install instructions

	sudo apt-get install chronograf

или прямое скачивание и установка дистрибутива:

    wget https://dl.influxdata.com/chronograf/releases/chronograf_1.10.6_amd64.deb
    sudo dpkg -i chronograf_1.10.6_amd64.deb

By default, Chronograf runs on localhost port 8888. Those settings are configurable; see the configuration file to change them and to see the other configuration options. 
We list the location of the configuration file `/etc/default/chronograf` by installation process below.

	HOST=0.0.0.0
	PORT=10000
	LOG_LEVEL=info    

And then start the Chronograf service:

    sudo service chronograf restart

Add Chronograf to autorun programs in file `/etc/rc.local`.

По умолчанию вебка доступна на порту `8888` (или `10000` внесены изменения в файл конфига):

    http://influx-host:10000


[Установка Kapacitor на Ubuntu](https://influxdata.com/downloads/)
==================================================================
Последняя поддерживаемая версия `Kapacitor` для `Influx 1.x` - `1.7.6-1`

`Kapacitor` позволяет настраивать реакции при наступлении определённых событий.

Ubuntu & Debian system install instructions

	sudo apt-get install kapacitor

или прямое скачивание и установка дистрибутива:

    wget https://dl.influxdata.com/kapacitor/releases/kapacitor_1.7.6-1_amd64.deb
    sudo dpkg -i kapacitor_1.7.6-1_amd64.deb

по умолчанию конфигурационный файл находится тут:

    /etc/kapacitor/kapacitor.conf

если необходимо получать данные из удалённого сервера InfluxDb нужно поменять в этом файле строку



Запустить и включить автозапуск
-------------------------------

    sudo systemctl enable --now kapacitor





Установка Telegraf на Ubuntu 22.04
==================================

Добавить репозиторий InfluxData
-------------------------------

    wget -qO- https://repos.influxdata.com/influxdata-archive_compat.key | sudo tee /etc/apt/trusted.gpg.d/influxdata.asc
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdata.asc] https://repos.influxdata.com/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/influxdata.list

    sudo apt update


Установить `telegraf`
---------------------

    sudo apt install telegraf


Запустить и включить автозапуск
-------------------------------

    sudo systemctl enable --now telegraf


Проверить статус
----------------

    sudo systemctl status telegraf



[Установка Telegraf на Ubuntu (старое)](https://influxdata.com/downloads/)
=================================================================
`Telegraf` собирает системную статистику об операционной системе.

Ubuntu & Debian system install instructions

    wget -q https://repos.influxdata.com/influxdb.key
    echo '23a1c8836f0afc5ed24e0486339d7cc8f6790b83886c4c96995b88a061c5bb5d influxdb.key' | sha256sum -c && cat influxdb.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list

	sudo apt-get update && sudo apt-get install telegraf


Настройка Telegraf для отдельного сервера
-----------------------------------------
Configuration file is here `/etc/telegraf/telegraf.conf`.

Создать новый конфиг (опционально):

    telegraf config > telegraf.conf


Установить название сервера
---------------------------
Это название будет являться названием измерения для возможности разделять данные, собранные с разных серверов.

		[agent]
			hostname = "{server_name}"


Установить адрес передачи в InfluxDB
------------------------------------
По умолчанию эта опция неактивна, т.к. `Telegraf` может передавать данные в разные системы сбора статистики.

		[[outputs.influxdb]]
			urls = ["udp://stat.totalapi.io:4444"]  # только на удалённых серверах
			database = "telegraf"


Запуск telegraf с выводом отладочной информации
-----------------------------------------------
 
		telegraf -debug             
			

Настройка плагинов Telegraf
===========================
По умолчанию в `Telegraf` включены только плагины, собирающие базовую системную информацию.

Чтобы изменения вступили в силу - в конце перезапусти Telegraf:

    sudo systemctl restart telegraf


Ngnix
-----
В `/etc/telegraf/telegraf.conf` раскомментируй или добавь:

    [[inputs.nginx]]
        urls = ["http://127.0.0.1/nginx_status"]
        # Можно не указывать
        [inputs.nginx.tags]
            host = "{server_name}"

Добавь файл `/etc/nginx/sites-available/nginx.stat` с содержимым:

    server {
        server_name _;
        listen 80 default_server;
        listen [::]:80 default_server;

        location /nginx_status {
            stub_status;
            allow 127.0.0.1;
            deny all;
        }
    }

Активируй его и перезагрузи `nginx`:

    sudo ln -s /etc/nginx/sites-available/nginx.stat /etc/nginx/sites-enabled/
    sudo systemctl reload nginx

Проверка доступности источника данных:

    curl http://127.0.0.1/nginx_status

Проверка работы плагина:

    telegraf --input-filter=nginx --test

Метрики, которые собираются:

* `active`, `accepts`, `handled`, `requests`
* `reading`, `writing`, `waiting`


InfluxDb
--------
В `/etc/telegraf/telegraf.conf` раскомментируй или добавь:

    [[inputs.influxdb]]
        urls = ["http://localhost:8086/debug/vars"]
        name_prefix = "influxdb_"
        # Можно не указывать
        [inputs.influxdb.tags]
            host = "{server_name}"

Проверка доступности источника данных:

    curl http://localhost:8086/debug/vars | jq

Проверка работы плагина:

    telegraf --input-filter=influxdb --test
    
Метрики, которые собираются - это метрики с endpoints `/debug/vars``, включая:

* `influxdb_httpd` — HTTP запросы
* `influxdb_write` — запись данных
* `influxdb_query` — статистика запросов
* `influxdb_tsm1_*` — кэш, блокировки, WAL
* `influxdb_runtime` — Go GC, allocs, goroutines и пр.

Работает только с `InfluxDB 1.x`. Порт `8086` должен быть доступен. Включён `debug/vars` (включено по умолчанию).


PostgreSQL
----------
В `/etc/telegraf/telegraf.conf` раскомментируй или добавь:

    [[inputs.postgresql]]
        address = "host=localhost user=postgres password=PASSWORD sslmode=disable"
        # Можно указать конкретную БД (по умолчанию — собираются данные по всем)
        databases = ["{db_name1}", "{db_name2}"]
        # Можно не указывать
        [inputs.postgresql.tags]
            host = "{server_name}"
    
Проверка работы плагина:

    telegraf --input-filter=postgresql --test

Метрики, которые собираются:

* `pg_stat_database` - общее число подключений, коммитов, ошибок и т.д.
* `pg_stat_bgwriter` - фоновые записи, контрольные точки
* `pg_stat_activity` - активные подключения
* `pg_stat_user_tables` - счётчики операций по таблицам (если включено)


Redis
-----
Плагин собирает метрики от Redis-сервера через команду `INFO`.

В `/etc/telegraf/telegraf.conf` раскомментируй или добавь:

    [[inputs.redis]]
        servers = ["tcp://localhost:6379"]
        # Если есть пароль:
        # password = "your_password"        
        
        # Можно не указывать
        [inputs.postgresql.tags]
            host = "{server_name}"
    
Проверка работы плагина:

    telegraf --input-filter=redis --test

Метрики, которые собираются:

* Общая статистика (`uptime`, `connected_clients`, `used_memory`, и т.д.)
* Статистика команд (`cmdstat_*`)
* Репликация (`role`, `connected_slaves`)
* Персистенция (`rdb`, `aof`)
* Сетевые метрики (`total_connections_received`, `total_commands_processed`)


PingL
----
Плагин используется для проверки доступности и задержки (latency) до указанных хостов через ICMP (ping).
    
В `/etc/telegraf/telegraf.conf` раскомментируй или добавь:

    [[inputs.ping]]
        urls = ["8.8.8.8", "1.1.1.1"]
        count = 1
        ping_interval = 1.0
        timeout = 2.0
        method = "exec"  # или "native" (если поддерживается)

💡 При использовании `native` нужен root (или capability `CAP_NET_RAW`).

Проверка работы плагина:

    telegraf --input-filter=ping --test

Метрики, которые собираются:

* `packets_transmitted`
* `packets_received`
* `percent_packet_loss`
* `average_response_ms`
* `maximum_response_ms`
* `minimum_response_ms`
* `standard_deviation_ms`

