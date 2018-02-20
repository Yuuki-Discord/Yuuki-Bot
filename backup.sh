#!/bin/sh
FOLDER="backup-$( date '+%Y-%m-%d-%H-%M')"
DRIVE_FOLDERID="1PzHBNso8Szt2movUpk1p3JBagBv_0i70"

echo "--create folder--"

mkdir -v $FOLDER

echo "--copy files--"

cp -rv data/ config/ $FOLDER

# yeah this only works with passwordless sudo, good thing its for personal use only!
sudo cp -v /var/lib/redis/dump.rdb $FOLDER
sudo chmod 777 $FOLDER/dump.rdb

echo "--upload raw files--"

gdrive upload --recursive $FOLDER -p $DRIVE_FOLDERID

echo "--create archive--"

tar -cvf ./$FOLDER.tar.gz $FOLDER

echo "--upload archive--"

gdrive upload --recursive $FOLDER.tar.gz -p $DRIVE_FOLDERID

echo "DONE!"
