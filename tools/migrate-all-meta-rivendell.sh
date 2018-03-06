# Migrate All Metadata for Rivendell push
echo "usage: migrate-all-meta-rivendell.sh <MySQL username> <MySQL password> <den username> <den password>"
echo "Rivendell Push complete export script."
echo "Warning! Script is interactive and will require input."
echo "Both MySQL and MongoDB must be running"
DATE=`date '+%Y-%m-%dh%Hm%M'`
logfile="../compost/migration_"$DATE".log"

# start with SQL update
./migrate-load-all-mysql-tables.sh $1 $2 

# export stations & datastreams
./migrate-export-odm-stations.sh ../data/migration2.1-rivendell/station 
./migrate-export-odm-datastreams.sh ../data/migration2.1-rivendell/datastream 

# Log into Dendra
den login $3 $4 

# import JSON to MongoDB
# Dendra: Push mixed migration JSON files to Mongo
# Once mysql exports have been started, remove all cases of migration1

# Basics - these don't change much
den meta push-schemes --filespec=../data/migration2-happyhybrid/scheme/* 
den meta push-schemes --filespec=../data/migration2.1-rivendell/scheme/* 

den meta push-soms --filespec=../data/migration2-happyhybrid/som/* 
den meta push-soms --filespec=../data/migration2.1-rivendell/som/* 

den meta push-uoms --filespec=../data/migration2-happyhybrid/uom/* 
den meta push-uoms --filespec=../data/migration2.1-rivendell/uom/* 

den meta push-places --filespec=../data/migration2-happyhybrid/place/* 

# organizations are hand created and should not be pulled from MySQL
den meta push-organizations --filespec=../data/migration2-happyhybrid/organization/* 

# vocabulary
den meta push-vocabularies --filespec=../data/migration2-happyhybrid/vocabulary/* 
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/vocabulary/* 

# dashboards
den meta push-dashboards --filespec=../data/migration2-happyhybrid/dashboard/* 
den meta push-dashboards --filespec=../data/migration2.1-rivendell/dashboard/*  

# assign station mongoid's to stations and datastreams
node ./migrate-stationid-inserter.js ../data/migration2.1-rivendell/ 

# stations
den meta push-stations --filespec=../data/migration2.1-rivendell/station/* 
den meta push-stations --save --filespec=../data/migration2.1-rivendell/station/* 

# datastreams
den meta push-datastreams --filespec=../data/migration2-happyhybrid/datastream/* 
den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/datastream/*

echo "RIVENDELL MIGRATION COMPLETE!" 
