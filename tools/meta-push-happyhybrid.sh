# Dendra: Push mixed migration JSON files to Mongo
den meta push-schemes --filespec=../data/migration2-happyhybrid/scheme/*
den meta push-soms --filespec=../data/migration2-happyhybrid/som/*
den meta push-uoms --filespec=../data/migration2-happyhybrid/uom/*
den meta push-vocabularies --filespec=../data/migration2-happyhybrid/vocabulary/*
den meta push-places --filespec=../data/migration2-happyhybrid/place/*
den meta push-organizations --filespec=../data/migration2-happyhybrid/organization/*
den meta push-stations --filespec=../data/migration1-preview/station/*
den meta push-stations --filespec=../data/migration2-happyhybrid/station/quail-ridge.station.json
den meta push-datastreams --filespec=../data/migration1-preview/datastream/*
den meta push-datastreams --filespec=../data/migration2-happyhybrid/datastream/*

