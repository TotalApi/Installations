rm -rf ./far2l_backup.tar.gz
cp -r ~/.config/far2l ./far2l_backup
cd ./far2l_backup
tar -czf ../far2l_backup.tar.gz .
cd ..
rm -rf ./far2l_backup