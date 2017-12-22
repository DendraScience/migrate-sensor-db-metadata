# Dendra: Push all JSON files to Mongo
# assumes you are in migrationN with subfolders
# do the migration-round2 first
den meta push-schemes --filespec=../data/migration-round1/scheme
den meta push-soms --filespec=../data/migration-round1/som/*
den meta push-uoms --filespec=../data/migration-round1/uom/*
den meta push-vocabularies --filespec=../data/migration-round1/vocabulary/*
den meta push-organizations --filespec=../data/migration-round1/organization/*
den meta push-persons --filespec=../data/migration-round1/person/*
den meta push-users --filespec=../data/migration-round1/user/*
den meta push-memberships --filespec=../data/migration-round1/membership/*
den meta push-places --filespec=../data/migration-round1/place/*
den meta push-stations --filespec=../data/migration-round1/station/*
#den meta push-things --filespec=../data/migration-round1/thing/*
den meta push-datastreams --filespec=../data/migration-round1/datastream/*
#den meta push-dashboards --filespec=../data/migration-round1/dashboard/*

