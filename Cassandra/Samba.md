[Установка Samba](https://ubuntu.com/tutorials/install-and-configure-samba)
===========================================================================

[Ссылка 1](https://1cloud.ru/help/network/nastroika-samba-v-lokalnoj-seti)
[Ссылка 2](http://www.howtogeek.com/howto/ubuntu/install-samba-server-on-ubuntu/)


Installing Samba
----------------

To install Samba, we run:

	sudo apt update
	sudo apt install samba

We can check if the installation was successful by running:

	whereis samba

The following should be its output:

	samba: /usr/sbin/samba /usr/lib/samba /etc/samba /usr/share/samba /usr/share/man/man7/samba.7.gz /usr/share/man/man8/samba.8.gz

Setting up Samba
----------------

Now that Samba is installed, we need to create a directory for it to share:

	mkdir /home/<username>/sambashare/

The command above creates a new folder `sambashare` in our home directory which we will share later.


В конфигурационном файле `/etc/samba/smb.conf` прописать следующие данные

    [global]
        workgroup = WORKGROUP
        security = user             
        map to guest = bad user     
        wins support = no           
        dns proxy = no              

    [sambashare]
	    comment = Samba on Ubuntu
	    path = /home/username/sambashare
	    read only = no
	    browsable = yes

    [cassandra_data]
        path = /var/lib/cassandra
        guest ok = yes
        force user = nobody
        browsable = yes
        writable = yes
        directory mask = 0777

    [cassandra_configs]
        path = /etc/cassandra
        guest ok = yes
        force user = nobody
        browsable = yes
        writable = yes
        directory mask = 0777

    [cassandra_logs]
        path = /var/log/cassandra
        guest ok = yes
        force user = nobody
        browsable = yes
        writable = yes
        directory mask = 0777



**What we’ve just added**

  - comment: A brief description of the share.
  - path: The directory of our share.
  - read only: Permission to modify the contents of the share folder is only granted when the value of this directive is no.
  - browsable: When set to yes, file managers such as Ubuntu’s default file manager will list this share under “Network” (it could also appear as browseable).

Now that we have our new share configured, save it and restart Samba for it to take effect:

	sudo service smbd restart

Update the firewall rules to allow Samba traffic:

	sudo ufw allow samba

Setting up User Accounts and Connecting to Share
------------------------------------------------

Since Samba doesn’t use the system account password, we need to set up a Samba password for our user account:

	sudo smbpasswd -a username

**Note: Username used must belong to a system account, else it won’t save.**


Enable access from Windows
--------------------------

- Open the Local Group Policy Editor (`gpedit. msc`).
- In the console tree, select `Computer Configuration` > `Administrative Templates` > `Network` > `Lanman Workstation`.
- For the setting, right-click `Enable insecure guest logons` and select Edit.
- Select `Enabled` and select OK.


[SambaServer Guide](https://help.ubuntu.com/community/Samba/SambaServerGuide)