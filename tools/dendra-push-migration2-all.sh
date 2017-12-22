# Dendra: Push all JSON files to Mongo
# assumes you are in migrationN with subfolders
den meta push-schemes --filespec=../data/migration-round2/scheme/*
den meta push-soms --filespec=../data/migration-round2/som/*
den meta push-uoms --filespec=../data/migration-round2/uom/*
den meta push-vocabularies --filespec=../data/migration-round2/vocabulary/*
den meta push-organizations --filespec=../data/migration-round2/organization/*
#den meta push-persons --filespec=../data/migration-round2/person/*
#den meta push-users --filespec=../data/migration-round2/user/*
#den meta push-memberships --filespec=../data/migration-round2/membership/*
den meta push-places --filespec=../data/migration-round2/place/*
den meta push-stations --filespec=../data/migration-round2/station/*
#den meta push-things --filespec=../data/migration-round2/thing/*
den meta push-datastreams --filespec=../data/migration-round2/datastream/*
#den meta push-dashboards --filespec=../data/migration-round2/dashboard/*

