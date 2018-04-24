# Extract and Transform All Metadata for Rivendell push
# Organizations are separated: use organization slug as directory name
echo "usage: extract-sensordb.sh <MySQL username> <MySQL password>"
echo "Rivendell Push extract and transform script."
DATE=`date '+%Y-%m-%dh%Hm%M'`
logfile="../compost/migration_"$DATE".log"

path="../data/migration2.1-rivendell/"
organization_list="ucnrs erczo"
host="gall.berkeley.edu" # "gall.berkeley.edu" # "localhost"

for orgslug in $organization_list 
do 
	# start with SQL update
	echo "Organization to Extract: $orgslug"
	echo ./extract-sensordb-load-sql-tables.sh $host $1 $2 $orgslug
	./extract-sensordb-load-sql-tables.sh $host $1 $2 $orgslug

	# export stations & datastreams
	echo ./extract-sensordb-export-sql-views.sh $host $1 $2 $path$orgslug/ 
	./extract-sensordb-export-sql-views.sh $host $1 $2 $path$orgslug/ 
	
	# assign station mongoid's to stations and datastreams
	# assign various external references 
	# Stations
	echo node ./transform-sensordb-insert-externalrefs-stations.js $path $orgslug 
	node ./transform-sensordb-insert-externalrefs-stations.js $path $orgslug
	# Datastreams
	echo node ./transform-sensordb-insert-externalrefs-datastreams.js $path $orgslug 
	node ./transform-sensordb-insert-externalrefs-datastreams.js $path $orgslug

	# map names to attributes for datastreams
	# note: org_slug needs to be passed in as a separate argument from path
	echo node ./transform-sensordb-map-names-to-attributes.js $path $orgslug 
	node ./transform-sensordb-map-names-to-attributes.js $path $orgslug

	# Create Influx Datapoints Configuration for Datastreams using External References
	echo node ./transform-sensordb-influxconfig.js  $path $orgslug
	node ./transform-sensordb-influxconfig.js  $path $orgslug
	
done

echo "RIVENDELL SENSOR DATABASE EXTRACTION & TRANSFORMATION COMPLETE!" 
