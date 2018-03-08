# Migrate Metadata to Mongo for Rivendell push
echo "usage: load-migration2.1-rivendell.sh <den username> <den password>"
echo "Rivendell Push loading script."

# Log into Dendra
den login $1 $2 

# COMMON METADATA
# Basics - these don't change much
# scheme
den meta push-schemes --filespec=../data/dendra-managed/common/scheme/*scheme.json 
den meta push-schemes --filespec=../data/migration2.1-rivendell/common/scheme/*scheme.json 
# som - system of measure (metric, imperial)
den meta push-soms --filespec=../data/dendra-managed/common/som/*som.json 
den meta push-soms --filespec=../data/migration2.1-rivendell/common/som/*som.json 
# uom - units of measure
den meta push-uoms --filespec=../data/dendra-managed/common/uom/*uom.json 
den meta push-uoms --filespec=../data/migration2.1-rivendell/common/uom/*uom.json 
# places
den meta push-places --filespec=../data/dendra-managed/common/place/*place.json 
den meta push-places --filespec=../data/migration2.1-rivendell/common/place/*place.json
# organizations 
den meta push-organizations --filespec=../data/dendra-managed/common/organization/*organization.json 
den meta push-organizations --filespec=../data/migration2.1-rivendell/common/organization/*organization.json
# vocabulary
den meta push-vocabularies --filespec=../data/dendra-managed/common/vocabulary/*vocabulary.json
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/common/vocabulary/*vocabulary.json 
# users
den meta push-vocabularies --filespec=../data/dendra-managed/common/user/*user.json
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/common/user/*user.json 
# people
den meta push-vocabularies --filespec=../data/dendra-managed/common/peson/*person.json
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/common/person/*person.json 
# membership
den meta push-vocabularies --filespec=../data/dendra-managed/common/membership/*membership.json
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/common/membership/*membership.json 
# thing-type
den meta push-vocabularies --filespec=../data/dendra-managed/common/thing-type/*thing-type.json
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/common/thing-type/*thing-type.json 


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
	# datastreams
	den meta push-datastreams --save --filespec=../data/dendra-managed/$orgslug/datastream/*datastream.json
	den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/$orgslug/datastream/*datastream.json
	# thing
	den meta push-stations --save --filespec=../data/dendra-managed/$orgslug/thing/*thing.json
	den meta push-stations --save --filespec=../data/migration2.1-rivendell/$orgslug/thing/*thing.json 
done
echo "RIVENDELL MIGRATION LOADED!" 
