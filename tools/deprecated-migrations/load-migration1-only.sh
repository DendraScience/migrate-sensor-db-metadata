# Migrate Metadata TO Mongo for Preview push
echo "usage: load-migration1-preview.sh <den username> <den password>"
echo "Preview Push loading script."

# Log into Dendra
den login $1 $2 

den meta push-schemes --filespec=../data/migration1-preview/scheme
den meta push-soms --filespec=../data/migration1-preview/som/*
den meta push-uoms --filespec=../data/migration1-preview/uom/*
den meta push-vocabularies --filespec=../data/migration1-preview/vocabulary/*
den meta push-organizations --filespec=../data/migration1-preview/organization/*
den meta push-persons --filespec=../data/migration1-preview/person/*
den meta push-users --filespec=../data/migration1-preview/user/*
den meta push-memberships --filespec=../data/migration1-preview/membership/*
den meta push-places --filespec=../data/migration1-preview/place/*
den meta push-stations --filespec=../data/migration1-preview/station/*
#den meta push-things --filespec=../data/migration1-preview/thing/*
den meta push-datastreams --filespec=../data/migration1-preview/datastream/*
#den meta push-dashboards --filespec=../data/migration1-preview/dashboard/*

