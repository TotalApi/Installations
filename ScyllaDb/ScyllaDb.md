Установка ScyllaDb 5.2 на Ubuntu
================================

- [Статья 1](https://opensource.docs.scylladb.com/stable/getting-started/install-scylla/install-on-linux.html#)
- [Статья 2](https://www.scylladb.com/download/#open-source)


Пошаговая инструкция
====================

Отключение запрашивания пароля `sudo` (если нужно)
--------------------------------------------------

Добавить в файл `/etc/sudoers`:

    %sudo ALL=NOPASSWD: ALL



Install a repo file and add the ScyllaDB APT repository to your system
-------------------------------------------------------------------------

    sudo mkdir -p /etc/apt/keyrings
    sudo gpg --homedir /tmp --no-default-keyring --keyring /etc/apt/keyrings/scylladb.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys a43e06657bac99e3
    sudo wget -O /etc/apt/sources.list.d/scylla.list http://downloads.scylladb.com/deb/debian/scylla-6.2.list



Install ScyllaDB packages
-------------------------

    sudo apt-get update
    sudo apt-get install -y scylla



Install Java OpenJDK
--------------------
ScyllaDb needs OpenJDK 8+ to run on an Ubuntu system. 
Update your package repository first:

    sudo apt update

When the process finishes, install OpenJDK 11 using the following command:

    sudo apt-get install -y openjdk-11-jre-headless
    sudo update-java-alternatives --jre-headless -s java-1.11.0-openjdk-amd64

When the installation completes, test if Java was installed successfully checking the Java version:

    java -version


Run the scylla_setup script to tune the system settings and determine the optimal configuration
-----------------------------------------------------------------------------------------------

    sudo scylla_setup


Run ScyllaDB as a service (if not already running)
--------------------------------------------------

    sudo systemctl start scylla-server

Now you can start using ScyllaDB. Here are some tools you may find useful.

Run nodetool:

    nodetool status

Run cqlsh:

    cqlsh

Run cassandra-stress:

    cassandra-stress write -mode cql3 native
