# Migrate Metadata to Mongo for Rivendell push
echo "usage: load-migration2.1-rivendell.sh <den username> <den password>"
echo "Rivendell Push loading script."

# Log into Dendra
den login $1 $2 

# COMMON METADATA
# Basics - these don't change much
migration_list="dendra-managed migration2.1-rivendell"
for mig in $migration_list
do
	# scheme
	den meta push-schemes --filespec=../data/$mig/common/scheme/*scheme.json 
	# som - system of measure (metric, imperial)
	den meta push-soms --filespec=../data/$mig/common/som/*som.json 
	# uom - units of measure
	den meta push-uoms --filespec=../data/$mig/common/uom/*uom.json 
	# places
	den meta push-places --filespec=../data/$mig/common/place/*place.json 
	# organizations 
	den meta push-organizations --filespec=../data/$mig/common/organization/*organization.json 
	# vocabulary
	den meta push-vocabularies --filespec=../data/$mig/common/vocabulary/*vocabulary.json
	# users
	den meta push-users --filespec=../data/$mig/common/user/*user.json
	# people
	den meta push-persons --filespec=../data/$mig/common/person/*person.json
	# membership
	den meta push-memberships --filespec=../data/$mig/common/membership/*membership.json
	# thing-type
	#den meta push-thing-types --filespec=../data/$mig/common/thing-type/*thing-type.json
done

# ORGANIZATION SPECIFIC METADATA
organization_list="erczo ucnrs"
for orgslug in $organization_list 
do 
	# dashboards
	den meta push-dashboards --filespec=../data/dendra-managed/$orgslug/dashboard/*dashboard.json  
	den meta push-dashboards --filespec=../data/migration2.1-rivendell/$orgslug/dashboard/*dashboard.json 
	# stations
	den meta push-stations --save --filespec=../data/dendra-managed/$orgslug/station/*station.json
	den meta push-stations --save --filespec=../data/migration2.1-rivendell/$orgslug/station/*station.json 
	# thing
	den meta push-things --save --filespec=../data/dendra-managed/$orgslug/thing/*thing.json
	den meta push-things --save --filespec=../data/migration2.1-rivendell/$orgslug/thing/*thing.json 
	# datastreams
	den meta push-datastreams --save --filespec=../data/dendra-managed/$orgslug/datastream/*datastream.json
	den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/$orgslug/datastream/*datastream.json
	
	# Transform datastream - add derived mongoid
	node ./transform-sensordb-derivedid-inserter.js ../data/migration2.1-rivendell/$orgslug/
	den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/$orgslug/datastream/*datastream.json
done
echo "RIVENDELL MIGRATION LOADED!" 
