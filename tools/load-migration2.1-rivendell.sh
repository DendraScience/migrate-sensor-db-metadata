# Migrate Metadata to Mongo for Rivendell push
# NOTE: Mongo database must be empty before load if you are pushing a new set of datastreams.
# Mongo can be populated if you are updating existing datastreams with modified json.
echo "Rivendell Migration loading script."
echo "usage: load-migration2.1-rivendell.sh <den username> <den password>"

# Log into Dendra
den login $1 $2 

# lists 
organization_list="erczo ucnrs"
migration_list="dendra-managed migration2.1-rivendell"

# COMMON METADATA
# Basics - these don't change much
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
		# TRANSFORM 
		# after the load - add mongoid for derived datasets 
		node ./transform-sensordb-derivedid-inserter.js ../data/migration2.1-rivendell/$orgslug/
		den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/$orgslug/datastream/*datastream.json

	done
done

echo "RIVENDELL MIGRATION LOADED!" 
