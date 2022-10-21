Установка Cassandra 3.x на Ubuntu
=================================

- [Статья 1](http://wiki.apache.org/cassandra/DebianPackaging)
- [Статья 2](https://phoenixnap.com/kb/install-cassandra-on-ubuntu)


Пошаговая инструкция
====================

Отключение запрашивания пароля `sudo` (если нужно)
--------------------------------------------------

Добавить в файл `/etc/sudoers`:

    %sudo ALL=NOPASSWD: ALL


Install Java OpenJDK
--------------------
Apache Cassandra needs OpenJDK 8 to run on an Ubuntu system. 
Update your package repository first:

    sudo apt update

When the process finishes, install OpenJDK 8 using the following command:

    sudo apt install openjdk-8-jdk -y

When the installation completes, test if Java was installed successfully checking the Java version:

    java -version



Install the apt-transport-https Package
---------------------------------------
Next, install the APT transport package. You need to add this package to your system to enable access to the repositories using HTTPS.
Enter this command:

    sudo apt install apt-transport-https


Add Apache Cassandra Repository and Import GPG Key
--------------------------------------------------
You need to add the Apache Cassandra repository and pull the GPG key before installing the database.
Enter the command below to add the Cassandra repository to the sources list:

    sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'

The output returns to a new line with no message.

Then, use the wget command to pull the public key from the URL below:

    sudo apt install -y gnupg2
    wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

If you entered the command and the URL correctly, the output prints OK.



Install Apache Cassandra
------------------------
You are now ready to install Cassandra on Ubuntu.

Update the repository package list:

    sudo apt update

Then, run the install command:

    sudo apt install cassandra



Verify Apache Cassandra Installation
------------------------------------
Finally, to make sure the Cassandra installation process completed properly, check cluster status:

    nodetool status

The UN letters in the output signal that the cluster is working.

You can also check Cassandra status by entering:

    sudo systemctl status cassandra

The output should display active (running) in green.



Commands to Start, Stop, and Restart Cassandra Service
------------------------------------------------------
    
    sudo systemctl start cassandra
    sudo systemctl stop cassandra
    sudo systemctl restart cassandra



Start Apache Cassandra Service Automatically on Boot
----------------------------------------------------
When you turn off or reboot your system, the Cassandra service switches to inactive.

To start Cassandra automatically after booting up, use the following command:

    sudo systemctl enable cassandra

Now, if your system reboots, the Cassandra service is enabled automatically.


- Конфиг: `/etc/cassandra/cassandra.yaml`
- Базы данных: `/var/lib/cassandra/data`
- Логи: `/var/log/cassandra`



(Настройки конфига)[cassandra.yaml]
-----------------------------------

    listen_address: xxx.xxx.xxx.xxx # localhost
    rpc_address: xxx.xxx.xxx.xxx    # localhost
    file_cache_size_in_mb: 2048     # 512
    auto_snapshot: false            # true 
    #incremental_backups: false      # false

    # clustering support
    #endpoint_snitch: GossipingPropertyFileSnitch # SimpleSnitch

    seed_provider:
        - class_name: org.apache.cassandra.locator.SimpleSeedProvider
          parameters:
            - seeds: "xxx.xxx.xxx.xxx"


Использование отдельного диска для БД Cassandra
-----------------------------------------------

Если есть возможность, следует разделить диск на котором находится `Commit Log` и диск с данными. Самый простой способ - сделать каталог БД символической ссылкой на другой диск:

	sudo systemctl stop cassandra
	sudo mount -t ext4 /dev/sdb1 /var/lib/cassandra/data
	sudo chown -R cassandra:cassandra /var/lib/cassandra/data
	sudo systemctl start cassandra

Для постоянного монтирования необходимо добавить в файл `/etc/fstab` строчку

    /dev/sdb1 /var/lib/cassandra/data auto defaults,nofail 0 2
или
	UUID={uuid} /var/lib/cassandra/data auto defaults,nofail 0 2

Лучше указывать диск по его UUID, узнать который можно:

	sudo blkid



Улучшение производительности
============================
[Статья 1](https://docs.datastax.com/en/cassandra-oss/2.1/cassandra/install/installRecommendSettings.html)
[Статья 2](https://intellipaat.com/tutorial/cassandra-tutorial/tuning-cassandra-performance)
[Статья 3](https://medium.com/linagora-engineering/tunning-cassandra-performances-7d8fa31627e3)


Disable swap
------------
Failure to disable swap entirely can severely lower performance. Because Cassandra has multiple replicas and transparent failover, it is preferable for a replica to be killed immediately when memory is low rather than go into swap. This allows traffic to be immediately redirected to a functioning replica instead of continuing to hit the replica that has high latency due to swapping. If your system has a lot of DRAM, swapping still lowers performance significantly because the OS swaps out executable code so that more DRAM is available for caching disks.

If you insist on using swap, you can set `vm.swappiness=1`. This allows the kernel swap out the absolute least used parts.

	sudo swapoff --all

To make this change permanent, remove all swap file entries from `/etc/fstab`.


TCP settings
------------
To handle thousands of concurrent connections used by Cassandra, DataStax recommends these settings to optimize the Linux network stack. 

Add these settings to `/etc/sysctl.conf` (or `/etc/sysctl.d/filename.conf`):

    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.core.rmem_default = 16777216
    net.core.wmem_default = 16777216
    net.core.optmem_max = 40960
    net.ipv4.tcp_rmem = 4096 87380 16777216
    net.ipv4.tcp_wmem = 4096 65536 16777216

To set immediately (depending on your distribution):
    
    sudo sysctl -p /etc/sysctl.conf
    #OR...
    #sudo sysctl -p /etc/sysctl.d/filename.conf


Optimize SSDs
-------------
The default SSD configurations on most Linux distributions are not optimal. Follow these steps to ensure the best settings for SSDs:

1. Ensure that the `SysFS` rotational flag is set to `false` (zero).
   This overrides any detection by the operating system to ensure the drive is considered an SSD.

2. Apply the same rotational flag setting for any block devices created from SSD storage, such as mdarrays.

3. Set the IO scheduler to either `deadline` or `noop`:
   - The `noop` scheduler is the right choice when the target block device is an array of SSDs behind a high-end IO controller that performs IO optimization.
   - The `deadline` scheduler optimizes requests to minimize IO latency. If in doubt, use the `deadline` scheduler.

4. Set the `readahead` value for the block device to 8 KB.
   This setting tells the operating system not to read extra bytes, which can increase IO time and pollute the cache with bytes that weren’t requested by the user.

For example, if the SSD is `/dev/sda`, in `/etc/rc.local`:

	echo deadline > /sys/block/sda/queue/scheduler
    #OR...
    #echo noop > /sys/block/sda/queue/scheduler
    touch /var/lock/subsys/local
    echo 0 > /sys/class/block/sda/queue/rotational
    echo 8 > /sys/class/block/sda/queue/read_ahead_kb

If `/etc/rc.local` is absent you must create it:

	sudo echo '#!/bin/sh -e' > /etc/rc.local
	sudo chmod u+x /etc/rc.local

Immediately apply and check settings:
	
	systemctl start rc-local
	systemctl status rc-local


Check the Java Hugepages setting
--------------------------------
Many modern Linux distributions ship with Transparent Hugepages enabled by default. When Linux uses Transparent Hugepages, the kernel tries to allocate memory in large chunks (usually 2MB), rather than 4K. This can improve performance by reducing the number of pages the CPU must track. However, some applications still allocate memory based on 4K pages. This can cause noticeable performance problems when Linux tries to defrag 2MB pages. 
For more information, see Cassandra [Java Huge Pages](https://tobert.github.io/tldr/cassandra-java-huge-pages.html) and this [RedHat bug report](https://bugzilla.redhat.com/show_bug.cgi?id=879801).

To solve this problem, disable `defrag` for hugepages. Enter:

	echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag


Set user resource limits
------------------------
Use the `ulimit -a` command to view the current limits. Although limits can also be temporarily set using this command, DataStax recommends making the changes permanent:

Package installations: Ensure that the following settings are included in the `/etc/security/limits.d/cassandra.conf` file:

	<cassandra_user> - memlock unlimited
    <cassandra_user> - nofile 100000
    <cassandra_user> - nproc 32768
    <cassandra_user> - as unlimited

Tarball installations: In RHEL version 6.x, ensure that the following settings are included in the `/etc/security/limits.conf` file:

	<cassandra_user> - memlock unlimited
    <cassandra_user> - nofile 100000
    <cassandra_user> - nproc 32768
    <cassandra_user> - as unlimited

If you run Cassandra as root, some Linux distributions such as Ubuntu, require setting the limits for root explicitly instead of using cassandra_user:

	root - memlock unlimited
    root - nofile 100000
    root - nproc 32768
    root - as unlimited

For RHEL 6.x-based systems, also set the nproc limits in `/etc/security/limits.d/90-nproc.conf`:

	cassandra_user - nproc 32768

For all installations, add the following line to `/etc/sysctl.conf`:

	vm.max_map_count = 1048575

For installations on Debian and Ubuntu operating systems, the pam_limits.so module is not enabled by default. Edit the `/etc/pam.d/su` file and uncomment this line:

	session    required   pam_limits.so

This change to the PAM configuration file ensures that the system reads the files in the `/etc/security/limits.d` directory.
To make the changes take effect, reboot the server or run the following command:
	
	sudo sysctl -p

To confirm the limits are applied to the Cassandra process, run the following command where `{pid}` is the process ID of the currently running Cassandra process:
	
	cat /proc/{pid}/limits


Set the heap size for optimal Java garbage collection in Cassandra
------------------------------------------------------------------
See [Tuning Java resources](https://docs.datastax.com/en/cassandra-oss/2.1/cassandra/operations/ops_tune_jvm_c.html).


Disable zone_reclaim_mode on NUMA systems
-----------------------------------------
The Linux kernel can be inconsistent in enabling/disabling `zone_reclaim_mode`. This can result in odd performance problems.

  * Random huge CPU spikes resulting in large increases in latency and throughput.
  * Programs hanging indefinitely apparently doing nothing.
  * Symptoms appearing and disappearing suddenly.
  * After a reboot, the symptoms generally do not show again for some time.

To ensure that `zone_reclaim_mode` is disabled:

	echo 0 > /proc/sys/vm/zone_reclaim_mode


Apply optimum blockdev --setra settings for RAID on spinning disks
------------------------------------------------------------------
Typically, a `readahead` of 128 is recommended.

Check to ensure `setra` is not set to 65536:

	sudo blockdev --report /dev/spinning_disk

To set setra:

	sudo blockdev --setra 128 /dev/spinning_disk

**Note:** The recommended setting for RAID on SSDs is the same as that for SSDs that are not being used in a RAID installation. 
For details, see [Optimizing SSDs](https://docs.datastax.com/en/cassandra-oss/2.1/cassandra/install/installRecommendSettings.html#installRecommendSettings__optimizing-ssds).


Use the optimum `--setra` setting for RAID on SSD
-------------------------------------------------
The optimum readahead setting for RAID on SSDs (in Amazon EC2) is 8KB, the same as it is for non-RAID SSDs. 
For details, see [Optimizing SSDs](https://docs.datastax.com/en/cassandra-oss/2.1/cassandra/install/installRecommendSettings.html#installRecommendSettings__optimizing-ssds).


Synchronize clocks
------------------
Synchronize the clocks on all nodes, using NTP (Network Time Protocol) or other methods.

This is required because Cassandra only overwrites a column if there is another version whose timestamp is more recent.


Make sure that new settings persist after reboot
------------------------------------------------
**CAUTION**: Depending on your environment, some of the following settings may not be persisted after reboot. 
Check with your system administrator to ensure they are viable for your environment.

