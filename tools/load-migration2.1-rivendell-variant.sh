# Migrate Metadata to Mongo for Rivendell push
echo "usage: load-migration2.1-rivendell.sh <den username> <den password>"
echo "Rivendell Push loading script."

# Log into Dendra
den login $1 $2 

# COMMON METADATA
# Basics - these don't change much
# scheme
migration_list="dendra-managed migration2.1-rivendell"
meta_list="scheme som uom place organization vocabulary user person membership " # thing-type
for mig in $migration_list
do
	for meta in $meta_list
	do
		den meta push-$meta --filespec=../data/$mig/common/$meta/*$meta.json 
	done
done

# ORGANIZATION SPECIFIC METADATA
organization_list="erczo ucnrs"
for orgslug in $organization_list 
do 
	for mig in $migration_list
	do
		# dashboards
		den meta push-dashboards --filespec=../data/dendra-managed/$orgslug/dashboard/*dashboard.json  
		# stations
		den meta push-stations --save --filespec=../data/dendra-managed/$orgslug/station/*station.json
		# thing
		den meta push-things --save --filespec=../data/dendra-managed/$orgslug/thing/*thing.json
		# datastreams
		den meta push-datastreams --save --filespec=../data/dendra-managed/$orgslug/datastream/*datastream.json
	done
done

# AFTER THE FACT TRANSFORM
for orgslug in $organization_list 
do 
	#node ./transform-sensordb-derivedid-inserter.js ../data/migration2.1-rivendell/$orgslug/
	#den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/$orgslug/datastream/*datastream.json
done
echo "RIVENDELL MIGRATION LOADED!" 
