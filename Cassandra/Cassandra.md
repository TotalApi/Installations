Установка Cassandra 3.x на Ubuntu
=================================

- [Статья 1](http://wiki.apache.org/cassandra/DebianPackaging)
- [Статья 2](https://phoenixnap.com/kb/install-cassandra-on-ubuntu)


Пошаговая инструкция
====================

Install Java OpenJDK
--------------------
Apache Cassandra needs OpenJDK 8 to run on an Ubuntu system. 
Update your package repository first:

    $ sudo apt update

When the process finishes, install OpenJDK 8 using the following command:

    $ sudo apt install openjdk-8-jdk -y

When the installation completes, test if Java was installed successfully checking the Java version:

    $ java -version



Install the apt-transport-https Package
---------------------------------------
Next, install the APT transport package. You need to add this package to your system to enable access to the repositories using HTTPS.
Enter this command:

    $ sudo apt install apt-transport-https

Add Apache Cassandra Repository and Import GPG Key
--------------------------------------------------
You need to add the Apache Cassandra repository and pull the GPG key before installing the database.
Enter the command below to add the Cassandra repository to the sources list:

    $ sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'

The output returns to a new line with no message.

Then, use the wget command to pull the public key from the URL below:

    $ sudo apt install -y gnupg2
    $ wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

If you entered the command and the URL correctly, the output prints OK.



Install Apache Cassandra
------------------------
You are now ready to install Cassandra on Ubuntu.

Update the repository package list:

    $ sudo apt update

Then, run the install command:

    $ sudo apt install cassandra



Verify Apache Cassandra Installation
------------------------------------
Finally, to make sure the Cassandra installation process completed properly, check cluster status:

    $ nodetool status

The UN letters in the output signal that the cluster is working.

You can also check Cassandra status by entering:

    $ sudo systemctl status cassandra

The output should display active (running) in green.



Commands to Start, Stop, and Restart Cassandra Service
------------------------------------------------------
    
    $ sudo systemctl start cassandra
    $ sudo systemctl restart cassandra
    $ sudo systemctl stop cassandra



Start Apache Cassandra Service Automatically on Boot
----------------------------------------------------
When you turn off or reboot your system, the Cassandra service switches to inactive.

To start Cassandra automatically after booting up, use the following command:

    $ sudo systemctl enable cassandra

Now, if your system reboots, the Cassandra service is enabled automatically.

Конфиг: `/etc/cassandra/cassandra.yaml`
Базы данных: `/var/lib/cassandra/data`
Логи: `/var/log/cassandra`



Настройки конфига
-----------------

    listen_address: xxx.xxx.xxx.xxx # localhost
    rpc_address: xxx.xxx.xxx.xxx    # localhost
    file_cache_size_in_mb: 2048     # 512.
    auto_snapshot: false            # true 
    incremental_backups: false      # false

    # для создания кластера
    endpoint_snitch: GossipingPropertyFileSnitch # SimpleSnitch
