# Migrate Metadata TO Mongo for Preview push
echo "usage: load-migration2-happyhybrid.sh <den username> <den password>"
echo "HappyHybrid Push loading script."

# Log into Dendra
den login $1 $2 

# Core metadata from migration2-happyhybrid
den meta push-schemes --filespec=../data/migration2-happyhybrid/scheme/*
den meta push-vocabularies --filespec=../data/migration2-happyhybrid/vocabulary/*
den meta push-soms --filespec=../data/migration2-happyhybrid/som/*
den meta push-uoms --filespec=../data/migration2-happyhybrid/uom/*
den meta push-places --filespec=../data/migration2-happyhybrid/place/*
den meta push-organizations --filespec=../data/migration2-happyhybrid/organization/*

# Stations and datastreams from migration1-preview
den meta push-stations --filespec=../data/migration1-preview/station/*
den meta push-datastreams --filespec=../data/migration1-preview/datastream/*

# Stations and datastreams from migration2-happyhybrid
den meta push-stations --filespec=../data/migration2-happyhybrid/station/quail-ridge.station.json
den meta push-datastreams --filespec=../data/migration2-happyhybrid/datastream/*

# Dashboards from migration2-happyhybrid
den meta push-dashboards --filespec=../data/migration2-happyhybrid/dashboard/*
