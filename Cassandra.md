[Удаление tombstones](https://stackoverflow.com/questions/40796714/how-to-delete-tombstones-of-cassandra-table)
nodetool garbagecollect Telematics_GorTrans device
nodetool garbagecollect Telematics_Dev_Emu devicecoordinate

[Улучшение производительности 1](https://intellipaat.com/tutorial/cassandra-tutorial/tuning-cassandra-performance)
[Улучшение производительности 2](https://medium.com/linagora-engineering/tunning-cassandra-performances-7d8fa31627e3)


[Моделирование данных в Cassandra 2.0 на CQL3](https://habr.com/post/203200/)
[Опыт спасения кластера Cassandra](https://habr.com/post/114160/)
[Калькулятор размера базы](http://btoddb-cass-storage.blogspot.com/)
[Калькулятор параметров кластера](https://www.ecyrd.com/cassandracalculator)






[Установка Cassandra 3.x на Ubuntu](http://wiki.apache.org/cassandra/DebianPackaging)
                                   (https://phoenixnap.com/kb/install-cassandra-on-ubuntu)
Install Java OpenJDK
====================
Apache Cassandra needs OpenJDK 8 to run on an Ubuntu system. 
Update your package repository first:

    $ sudo apt update

When the process finishes, install OpenJDK 8 using the following command:

    $ sudo apt install openjdk-8-jdk -y

When the installation completes, test if Java was installed successfully checking the Java version:

    $ java -version


Install the apt-transport-https Package
=======================================
Next, install the APT transport package. You need to add this package to your system to enable access to the repositories using HTTPS.
Enter this command:

    $ sudo apt install apt-transport-https

Add Apache Cassandra Repository and Import GPG Key
==================================================
You need to add the Apache Cassandra repository and pull the GPG key before installing the database.
Enter the command below to add the Cassandra repository to the sources list:

    $ sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'

The output returns to a new line with no message.

Then, use the wget command to pull the public key from the URL below:

    $ sudo apt install -y gnupg2
    $ wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

If you entered the command and the URL correctly, the output prints OK.

Install Apache Cassandra
========================
You are now ready to install Cassandra on Ubuntu.

Update the repository package list:

    $ sudo apt update

Then, run the install command:

    $ sudo apt install cassandra

Verify Apache Cassandra Installation
====================================
Finally, to make sure the Cassandra installation process completed properly, check cluster status:

    $ nodetool status

The UN letters in the output signal that the cluster is working.

You can also check Cassandra status by entering:

    $ sudo systemctl status cassandra

The output should display active (running) in green.

Commands to Start, Stop, and Restart Cassandra Service
======================================================
    
    $ sudo systemctl start cassandra
    $ sudo systemctl restart cassandra
    $ sudo systemctl stop cassandra

Start Apache Cassandra Service Automatically on Boot
====================================================
When you turn off or reboot your system, the Cassandra service switches to inactive.

To start Cassandra automatically after booting up, use the following command:

    $ sudo systemctl enable cassandra

Now, if your system reboots, the Cassandra service is enabled automatically.

Конфиг: `/etc/cassandra/cassandra.yaml`
Базы данных: `/var/lib/cassandra/data`
Логи: `/var/log/cassandra`

Настройки конфига
=================

    listen_address: 91.211.88.229 # localhost
    rpc_address: 91.211.88.229    # localhost
    file_cache_size_in_mb: 2048   # 512.
    auto_snapshot: false          # true 
    incremental_backups: false    # false

    # для создания кластера
    endpoint_snitch: GossipingPropertyFileSnitch # SimpleSnitch




[Установка Cassandra 2.1 на Ubuntu](http://docs.datastax.com/en/cassandra/2.2/cassandra/install/installDeb.html)
                                   (https://cassandra.apache.org/download)
===

Add the DataStax Community repository to the `/etc/apt/sources.list.d/cassandra.sources.list`

    $ echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

Add the DataStax repository key to your aptitude trusted keys. 

    $ curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -

Install the latest package:

    $ sudo apt-get update
    $ sudo apt-get install cassandra
    $ sudo apt-get install cassandra-tools ## Optional utilities


Because the Debian packages start the Cassandra service automatically, you must stop the server and clear the data:
Doing this removes the default cluster_name (Test Cluster) from the system table. All nodes must use the same cluster name.

    $ sudo service cassandra stop
    $ sudo rm -rf /var/lib/cassandra/data/system/*

[Установка Cassandra 3.x на Ubuntu](http://wiki.apache.org/cassandra/DebianPackaging)
===

Add the DataStax repository to the `/etc/apt/sources.list.d/cassandra.sources.list`

    $ echo "deb http://www.apache.org/dist/cassandra/debian 34x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
    $ echo "deb-src http://www.apache.org/dist/cassandra/debian 34x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

You will want to replace 34x by the series you want to use: 34x for the 3.4.x series, 12x for the 1.2.x series, etc... 
You will not automatically get major version updates unless you change the series, but that is a feature. 

Add the the PUBLIC_KEY

    $ gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
    $ gpg --export --armor F758CE318D77295D | sudo apt-key add -
    $ gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
    $ gpg --export --armor 2B5C1B00 | sudo apt-key add -
    $ gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
    $ gpg --export --armor 0353B12C | sudo apt-key add -

Prepare JAVA 8

    $ sudo add-apt-repository ppa:webupd8team/java

Prepare current database

    $ nodetool upgradesstables
    $ nodetool drain
    $ service cassandra stop

Install the latest packages

    $ sudo aptitude update
    $ sudo aptitude install oracle-java8-installer
    $ sudo aptitude install cassandra
    $ sudo aptitude install cassandra-tools ## Optional utilities
    $ service cassandra stop
    $ nodetool upgradesstables


Полезное

[Исправление ошибки "Error starting local jmx server"](http://stackoverflow.com/questions/33031214/unable-to-start-cassandra-dsc-on-mac-error-starting-local-jmx-server)
В принципе можно не делать



[Разрешение внешних подключений к серверу](http://stackoverflow.com/questions/20575640/datastax-devcenter-fails-to-connect-to-the-remote-cassandra-database)
====

Необходимо в файле `/etc/cassandra/cassandra.yaml` прописать следующие параметры: 

    start_native_transport: true        # по умолчанию уже установлено

    # Вариант №1
    rpc_interface: eth0                 # нужно указать реальное название сетевой карты, по умолчанию тут стоит eth1

    # Вариант №2
    rpc_address: 0.0.0.0                # по умолчанию тут стоит localhost
    broadcast_rpc_address: <server IP>  # можно не устанавливать



[Установка OpsCenter 5.x на Ubuntu](http://docs.datastax.com/en/opscenter/5.1/opsc/install/opscInstallDeb_t.html)
===

**ВНИМАНИЕ!**  Версии 5.x, включительно до 5.4, не работают с Cassandra 3.x

Modify the aptitude repository source list file (/etc/apt/sources.list.d/datastax.community.list).

    $ echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.community.list

Add the DataStax repository key to your aptitude trusted keys:

    $ curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -

Install the OpsCenter package using the APT Package Manager:

    $ sudo apt-get update
    $ sudo apt-get install opscenter

For most users, the out-of-box configuration should work just fine, but if you need to you can configure OpsCenter differently.

Start OpsCenter:

    $ sudo service opscenterd start

Connect to OpsCenter in a web browser using the following URL:

    http://opscenter-host:8888/




uuid: 16 bytes
timeuuid: 16 bytes
timestamp: 8 bytes
bigint: 8 bytes
counter: 8 bytes
double: 8 bytes
time: 8 bytes
inet: 4 bytes (IPv4) or 16 bytes (IPV6)
date: 4 bytes
float: 4 bytes
int 4 bytes
smallint: 2 bytes
tinyint: 1 byte
boolean: 1 byte (hopefully.. no source for this)
ascii: equires an estimate of average # chars * 1 byte/char
text/varchar: requires an estimate of average # chars * (avg. # bytes/char for language)
map/list/set/blob: an estimate