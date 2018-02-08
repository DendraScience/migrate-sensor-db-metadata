# Dendra: Push mixed migration JSON files to Mongo
# Once mysql exports have been started, remove all cases of migration1

# Basics - these don't change much
den meta push-schemes --filespec=../data/migration2-happyhybrid/scheme/*
den meta push-schemes --filespec=../data/migration2-happyhybid/scheme/*

den meta push-soms --filespec=../data/migration2-happyhybrid/som/*
den meta push-soms --filespec=../data/migration2.1-rivendell/som/*

den meta push-uoms --filespec=../data/migration2-happyhybrid/uom/*
den meta push-uoms --filespec=../data/migration2.1-rivendell/uom/*


# Org and place can change but haven't
den meta push-places --filespec=../data/migration2-happyhybrid/place/*
den meta push-places --filespec=../data/migration2.1-rivendell/place/*

den meta push-organizations --filespec=../data/migration2-happyhybrid/organization/*
den meta push-organizations --filespec=../data/migration2.1-rivendell/organization/*


# vocabulary, stations, datastreams
den meta push-vocabularies --filespec=../data/migration2-happyhybrid/vocabulary/*
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/vocabulary/*

den meta push-stations --filespec=../data/migration1-preview/station/*
den meta push-stations --filespec=../data/migration2-happyhybrid/station/quail-ridge.station.json
den meta push-stations --filespec=../data/migration2.1-rivendell/*

den meta push-datastreams --filespec=../data/migration1-preview/datastream/*
den meta push-datastreams --filespec=../data/migration2-happyhybrid/datastream/*
den meta push-datastreams --filespec=../data/migration2.1-rivendell/datastream/*

