[Установка Influx 1.x на Ubuntu](https://influxdata.com/downloads/)
===================================================================

Последняя поддерживаемая версия `Influx 1.x` - `1.8.10`

Debian and Ubuntu users can install the latest stable version of InfluxDB using the apt-get package manager. For Ubuntu users, you can add the InfluxData repository configuration by using the following commands:

    $ curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
    $ source /etc/lsb-release
    $ echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list


And then to install and start the InfluxDB service:

    $ sudo apt-get update && sudo apt-get install influxdb
    $ sudo service influxdb start

По умолчанию админка доступна по на порту `8083`:

    http://influx-host:8083


[Фишки InfluxDb](http://docs.influxdata.com)
============================================

Для доступа к админ консоли нужно подключится к контейнеру (если в Docker'е)
    
    $ sudo docker exec -i -t influxdb /bin/bash

Создать конфигурационный файл

    # influxd config > /etc/influxdb/influxdb.conf

Просмотр протокола:

	$ sudo journalctl -u influxdb.service > influxdb_all.log
	$ sudo journalctl -u influxdb.service -f  > influxdb_live_tail.log
	$ sudo journalctl -u influxdb.service -n 100  > influxdb_last_100.log


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

	[[http]]
  		access-log-path = "/var/log/influxdb/access_http.log"


Начальная настройка БД
----------------------

Для доступа к админ консоли нужно запустить 
    
    # influx

1. Создание новой базы

    > CREATE DATABASE stat_db    # stat_db - ИМЯ_БАЗЫ

2. Создание retention policy - сколько данные будут храниться в базе

    > USE stat_db                                                                   # stat_db - ИМЯ_БАЗЫ
    > CREATE RETENTION POLICY "seven_days" ON stat_db DURATION 7d REPLICATION 1     # stat_db - ИМЯ_БАЗЫ
    > CREATE USER root WITH PASSWORD 'P@ssw0rd' WITH ALL PRIVILEGES

3. Удаление измерения - аналог таблицы (в случае если изменились типы полей в измерении, то необходимо удалять все измерение)

    > DROP MEASUREMENT <ИМЯ_ИЗМЕРЕНИЯ>

4. Удаление данных из таблицы

    > DROP SERIES FROM <ИМЯ_ИЗМЕРЕНИЯ> [WHERE ...]


[Fixing SHOW MEASUREMENTS bug](https://github.com/influxdata/influxdb/issues/4395)
----------------------------------------------------------------------------------

Если сразу после установки `show measurements` возвращает пустое множество выполните в консоле Influx:
    
    > use stat_db
    > show measurements
    > insert foo value=12
    > show measurements

После записи реальных данных это измерение можно удалить:
	
	> drop measurement foo


    
[Установка Chronograf на Ubuntu](https://influxdata.com/downloads/)
===================================================================

Последняя поддерживаемая версия `Chronograf` для `Influx 1.x` - `1.10.0`

`Chronograf` нужен для отображения данных о собранной статистике.

Ubuntu & Debian 64-bit system install instructions

    $ wget https://dl.influxdata.com/chronograf/releases/chronograf_1.10.0_amd64.deb
    $ sudo dpkg -i chronograf_1.10.0_amd64.deb

By default, Chronograf runs on localhost port 8888. Those settings are configurable; see the configuration file to change them and to see the other configuration options. 
We list the location of the configuration file `/etc/default/chronograf` by installation process below.

	HOST=0.0.0.0
	PORT=8888
	LOG_LEVEL=info    

And then start the Chronograf service:

    $ sudo service chronograf start

Add Chronograf to autorun programs in file `/etc/rc.local`.

По умолчанию вебка доступна на порту `8888`:

    http://influx-host:8888



[Установка Telegraf на Ubuntu](https://influxdata.com/downloads/)
=================================================================

`Telegraf` собирает системную статистику об операционной системе.

Ubuntu & Debian system install instructions

    wget -q https://repos.influxdata.com/influxdb.key
    echo '23a1c8836f0afc5ed24e0486339d7cc8f6790b83886c4c96995b88a061c5bb5d influxdb.key' | sha256sum -c && cat influxdb.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list

	sudo apt-get update && sudo apt-get install telegraf


Настройка Telegraf для отдельного сервера
-----------------------------------------

 - Configuration file is here:

    	/etc/telegraf/telegraf.conf

 - Установить название сервера:

		[agent]
			hostname = "{server_name}"

- Установить адрес передачи в InfluxDB:

		[[outputs.influxdb]]
			urls = ["udp://stat.totalapi.io:4444"]  # только на удалённых серверах
			database = "telegraf"

- Запуск telegraf с выводом отладочной информации
 
		telegraf -debug             
			



[Установка Kapacitor на Ubuntu](https://influxdata.com/downloads/)
==================================================================

Последняя поддерживаемая версия `Kapacitor` для `Influx 1.x` - `1.6.5`

`Kapacitor` позволяет настраивать реакции при наступлении определённых событий.

Ubuntu & Debian system install instructions

    wget https://dl.influxdata.com/kapacitor/releases/kapacitor_1.6.5-1_amd64.deb
    sudo dpkg -i kapacitor_1.6.5-1_amd64.deb



 