#
# Настройка общих папок, доступных пользователю SFTP с персональным доступом
#
# Формат вызова:
# -------------
#     sudo setup_sftp_user <имя_пользователя> [-d]
# 
# параметр -d удаляет все текущие привязки
#


# Отключение истории команд для безопасной обработки символа !
set +H

# Параметры
USER_NAME="$1"                 # имя пользователя (первый параметр)

REMOVE=$([[ "$2" == "-d" ]] && echo 1)

# папка, доступная только этому пользователю по SFTP
# если через `:` указан путь к папке, то в этой папке будет создана символическая ссылка с именем пользователя, которая смотрит на внутреннюю папку
SFTP_FOLDER='Backups:/!Backups'

# общие папки, доступные SFTP-пользователю.
# Формат: <Internal_Folder2>:<External_Folder1>,<Internal_Folder2>:<External_Folder2>,..,<Internal_FolderN>:<External_FolderN>
COMMON_FOLDERS='Installs:/!Installs,Public:/!Backups/!Public'

# Обработка COMMON_FOLDERS
IFS=',' read -ra pairs <<< "$COMMON_FOLDERS"
for pair in "${pairs[@]}"; do
    IFS=':' read -r INTERNAL_COMMON_FOLDER EXTERNAL_COMMON_FOLDER <<< "$pair"
	if [ -n "$INTERNAL_COMMON_FOLDER" ] && [ -n "$EXTERNAL_COMMON_FOLDER" ]; then

        E_EXTERNAL_COMMON_FOLDER=$(printf '%s\n' "$EXTERNAL_COMMON_FOLDER" | sed 's/!/\\!/g')
        E_INTERNAL_COMMON_FOLDER=$(printf '%s\n' "$INTERNAL_COMMON_FOLDER" | sed 's/!/\\!/g')


        # создание MOUNT ссылки на папку $EXTERNAL_COMMON_FOLDER
		if mountpoint -q "/home/$USER_NAME/$INTERNAL_COMMON_FOLDER"; then
			umount /home/$USER_NAME/$INTERNAL_COMMON_FOLDER 2>/dev/null
		fi
		if [ -z "$REMOVE" ]; then
        	mkdir /home/$USER_NAME/$INTERNAL_COMMON_FOLDER 2>/dev/null
			mount --bind $EXTERNAL_COMMON_FOLDER /home/$USER_NAME/$INTERNAL_COMMON_FOLDER 1>/dev/null 2>/dev/null
			# сделать привязки постоянными
			if ! grep -q "$EXTERNAL_COMMON_FOLDER /home/$USER_NAME/$INTERNAL_COMMON_FOLDER" /etc/fstab; then
				echo "$EXTERNAL_COMMON_FOLDER /home/$USER_NAME/$INTERNAL_COMMON_FOLDER none bind 0 0" | tee -a /etc/fstab 1>/dev/null 2>/dev/null
		        echo "Постоянная привязка $EXTERNAL_COMMON_FOLDER -> /home/$USER_NAME/$INTERNAL_COMMON_FOLDER добавлена в /etc/fstab"
		    else
        		echo "Привязка $EXTERNAL_COMMON_FOLDER -> /home/$USER_NAME/$INTERNAL_COMMON_FOLDER уже существует в /etc/fstab"
		    fi
		else
			# удалить каталог монтирования
        	rm -r /home/$USER_NAME/$INTERNAL_COMMON_FOLDER 2>/dev/null
			# убрать постоянные привязки
			if grep -q "$EXTERNAL_COMMON_FOLDER /home/$USER_NAME/$INTERNAL_COMMON_FOLDER" /etc/fstab; then
                #ESCAPED_FOLDER=$(printf '%s\n' "$EXTERNAL_COMMON_FOLDER" | sed 's/!/\\!/g')
                #sed -i "\|$ESCAPED_FOLDER /home/$USER_NAME/$INTERNAL_COMMON_FOLDER|d" /etc/fstab
                sed -i "\|$E_EXTERNAL_COMMON_FOLDER /home/$USER_NAME/$E_INTERNAL_COMMON_FOLDER|d" /etc/fstab

        		echo "Постоянная привязка $EXTERNAL_COMMON_FOLDER -> /home/$USER_NAME/$INTERNAL_COMMON_FOLDER удалена из /etc/fstab"
		    fi
		fi
        #findmnt --real --kernel -o TARGET,SOURCE | grep "$EXTERNAL_COMMON_FOLDER"
	fi
done

# Обработка SFTP_FOLDER
IFS=':' read -r INTERNAL_FOLDER EXTERNAL_FOLDER <<< $SFTP_FOLDER
if [ -n "$INTERNAL_FOLDER" ]; then
    if [ -n "$EXTERNAL_FOLDER" ]; then
   	  # удаление символической ссылки в папке $EXTERNAL_FOLDER
   	  unlink $EXTERNAL_FOLDER/$USER_NAME 2>/dev/null
    fi
	if [ -z "$REMOVE" ]; then
    	# cоздание подкаталога для данных и назанчение его пользователю
	    mkdir /home/$USER_NAME/$INTERNAL_FOLDER 2>/dev/null
    	chown $USER_NAME:sftp_users /home/$USER_NAME/$INTERNAL_FOLDER
	    if [ -n "$EXTERNAL_FOLDER" ]; then
    	  # создание символической ссылки в папке $EXTERNAL_FOLDER
	      mkdir $EXTERNAL_FOLDER 2>/dev/null
    	  ln -s /home/$USER_NAME/$INTERNAL_FOLDER $EXTERNAL_FOLDER/$USER_NAME
	    fi
	fi
fi


