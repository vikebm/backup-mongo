PATH=/bin:$PATH
dt=`date +%y-%m-%d`
mongodump --db MY_DATABASE --username MY_USER --password MY_PASSWORD --authenticationDatabase admin --out /home/ubuntu/backup-files/backup-$dt
bash /home/ubuntu/dropbox_uploader.sh upload /home/ubuntu/backup-files/backup-$dt /backup-bds/backup-$dt
echo "EJECUTADO CORRECTAMENTE"