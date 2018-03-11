# Extract and Transform All Metadata for Rivendell push
# Organizations are separated: use organization slug as directory name
echo "usage: extract-sensordb.sh <MySQL username> <MySQL password>"
echo "Rivendell Push extract and transform script."
DATE=`date '+%Y-%m-%dh%Hm%M'`
logfile="../compost/migration_"$DATE".log"

organization_list="erczo ucnrs"
for orgslug in $organization_list 
do 
	echo "Organization to Extract: $orgslug"
	# start with SQL update
	echo ./extract-sensordb-load-sql-tables.sh $1 $2 $orgslug
	./extract-sensordb-load-sql-tables.sh $1 $2 $orgslug

	# export stations & datastreams
	echo ./extract-sensordb-export-sql-views.sh ../data/migration2.1-rivendell/$orgslug/ 
	./extract-sensordb-export-sql-views.sh ../data/migration2.1-rivendell/$orgslug/ 
	
	# assign station mongoid's to stations and datastreams
	echo node ./transform-sensordb-stationid-inserter.js ../data/migration2.1-rivendell/$orgslug/ 
	node ./transform-sensordb-stationid-inserter.js ../data/migration2.1-rivendell/$orgslug/

	# map names to attributes for datastreams
	# note: org_slug needs to be passed in as a separate argument from path
	echo node ./transform-sensordb-map-names-to-attributes.js ../data/migration2.1-rivendell/ $orgslug 
	node ./transform-sensordb-map-names-to-attributes.js ../data/migration2.1-rivendell/ $orgslug
done

echo "RIVENDELL SENSOR DATABASE EXTRACTION & TRANSFORMATION COMPLETE!" 
