# Dendra: Push all JSON files to Mongo
# assumes you are in migrationN with subfolders
den meta push-schemes --filespec=../data/migration2-happyhybrid/scheme/*
den meta push-soms --filespec=../data/migration2-happyhybrid/som/*
den meta push-uoms --filespec=../data/migration2-happyhybrid/uom/*
den meta push-vocabularies --filespec=../data/migration2-happyhybrid/vocabulary/*
den meta push-organizations --filespec=../data/migration2-happyhybrid/organization/*
#den meta push-persons --filespec=../data/migration2-happyhybrid/person/*
#den meta push-users --filespec=../data/migration2-happyhybrid/user/*
#den meta push-memberships --filespec=../data/migration2-happyhybrid/membership/*
den meta push-places --filespec=../data/migration2-happyhybrid/place/*
den meta push-stations --filespec=../data/migration2-happyhybrid/station/*
#den meta push-things --filespec=../data/migration2-happyhybrid/thing/*
den meta push-datastreams --filespec=../data/migration2-happyhybrid/datastream/*
#den meta push-dashboards --filespec=../data/migration2-happyhybrid/dashboard/*

