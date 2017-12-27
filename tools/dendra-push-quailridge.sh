# Dendra: Push mixed migration JSON files to Mongo
den meta push-schemes --filespec=../data/migration-round2/scheme/*
den meta push-soms --filespec=../data/migration-round2/som/*
den meta push-uoms --filespec=../data/migration-round2/uom/*
den meta push-vocabularies --filespec=../data/migration-round2/vocabulary/*
den meta push-places --filespec=../data/migration-round2/place/*
den meta push-organizations --filespec=../data/migration-round2/organization/*
den meta push-stations --filespec=../data/migration-round1/station/*
den meta push-stations --filespec=../data/migration-round2/station/quail-ridge.station.json
den meta push-datastreams --filespec=../data/migration-round1/datastream/*
den meta push-datastreams --filespec=../data/migration-round2/datastream/*

