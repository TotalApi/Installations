[Установка Samba](https://ubuntu.com/tutorials/install-and-configure-samba)
===========================================================================


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

The configuration file for Samba is located at `/etc/samba/smb.conf`. To add the new directory as a share, we edit the file by running:

	sudo nano /etc/samba/smb.conf

At the bottom of the file, add the following lines:

	[sambashare]
	    comment = Samba on Ubuntu
	    path = /home/username/sambashare
	    read only = no
	    browsable = yes

Then press `Ctrl-O` to save and `Ctrl-X` to exit from the nano text editor.

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

[SambaServer Guide](https://help.ubuntu.com/community/Samba/SambaServerGuide)