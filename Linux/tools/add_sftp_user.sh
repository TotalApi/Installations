#
# Добавление пользователя SFTP с персональным доступом только к одной папке (`/home/$USER_NAME/$SFTP_DIR`)
# Автоматически создаётся и применяется файл с правилом для SSHD
#
# Формат вызова:
# -------------
#     sudo add_sftp_user <имя_пользователя> [<пароль>]
# если пароль не указан - это будет <имя_пользователя>_sftp
#

# Параметры
USER_NAME="$1"                 # имя пользователя (первый параметр)
PASSWORD="$2"                  # пароль (второй параметр)	
GROUP="sftp_users"             # название группы для всех ограниченных SFTP-пользователей

# папка, доступная только этому пользователю по SFTP
# если через `:` указан путь к папке, то в этой папке будет создана символическая ссылка с именем пользователя, которая смотрит на внутреннюю папку
SFTP_FOLDER="Backups:\!Backups"                                       

# общие папки, доступные SFTP-пользователю.
# Формат: <Internal_Folder2>:<External_Folder1>,<Internal_Folder2>:<External_Folder2>,..,<Internal_FolderN>:<External_FolderN>
COMMON_FOLDERS="Installs:\!Installs,Public:\!Backups\!Public"      

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# cоздание группы для ограниченных пользователей
if ! getent group "$GROUP" >/dev/null; then
    groupadd "$GROUP"
    if [ $? -eq 0 ]; then
        echo "Группа $GROUP успешно создана!"
    else
        echo "Ошибка при создании группы $GROUP"
        exit 1
    fi
fi

# Настройка SFTP
tee /etc/ssh/sshd_config.d/"$GROUP".conf > /dev/null <<EOF
Match Group $GROUP
    ChrootDirectory /home/%u
    ForceCommand internal-sftp
    AllowTCPForwarding no
    X11Forwarding no
EOF

# Перезапуск SSHD
sshd -t && systemctl restart ssh

if [ -z "$USER_NAME" ]; then
    echo "Формат вызова:"
    echo "-------------"
    echo "    sudo add_sftp_user <имя_пользователя> [<пароль>]"
    exit 1
fi

if [ -z "$PASSWORD" ]; then
    PASSWORD="$USER_NAME"_sftp
fi

# создание пользователя и добавление пользователя в эту группу
if ! id "$USER_NAME" >/dev/null 2>&1; then
    # Создание пользователя с домашней директорией и добавлением в группу sftp_users
    useradd -m -G "$GROUP" "$USER_NAME"
    if [ $? -ne 0 ]; then
        echo "Ошибка при создании пользователя $USER_NAME"
        exit 1
    fi

    # Установка пароля
    echo "$USER_NAME:$PASSWORD" | chpasswd
    if [ $? -ne 0 ]; then
        echo "Ошибка при установке пароля для $USER_NAME"
        exit 1
    fi
    echo "Пользователь $USER_NAME успешно создан и добавлен в группу $GROUP с установленным паролем!"
else
    usermod -aG "$GROUP" "$USER_NAME"
    if [ $? -eq 0 ]; then
        echo "Существующий пользователь $USER_NAME успешно добавлен в группу $GROUP"
    else
        echo "Ошибка при назначении группы $GROUP пользователю $USER_NAME"
        exit 1
    fi
fi

# /home/имя_пользователя должен принадлежать root и иметь 755 (иначе chroot не сработает)
chown root:root /home/"$USER_NAME"
chmod 755 /home/"$USER_NAME"

# удаляем все скрытые подкаталоги
cd /home/"$USER_NAME" || exit 1
find . -maxdepth 1 -type d -name ".*" -exec rm -rf {} \; 2>/dev/null
find . -maxdepth 1 -type f -name ".*" -exec rm -f {} \; 2>/dev/null

# Настройка общих папок, доступных пользователю SFTP с персональным доступом
$SCRIPT_DIR/setup_sftp_user.sh $USER_NAME
