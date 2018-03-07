# Extract and Transform All Metadata for Rivendell push
echo "usage: extract-sensordb.sh <MySQL username> <MySQL password>"
echo "Rivendell Push extract and transform script."
DATE=`date '+%Y-%m-%dh%Hm%M'`
logfile="../compost/migration_"$DATE".log"

# start with SQL update
./extract-sensordb-load-sql-tables.sh $1 $2 

# export stations & datastreams
./extract-sensordb-export-sql-views.sh ../data/migration2.1-rivendell/ 

# assign station mongoid's to stations and datastreams
node ./transform-sensordb-stationid-inserter.js ../data/migration2.1-rivendell/ 

# map names to attributes for datastreams
# node ./transform-map-names-to-attributes.js

echo "RIVENDELL SENSOR DATABASE EXTRACTION & TRANSFORMATION COMPLETE!" 
