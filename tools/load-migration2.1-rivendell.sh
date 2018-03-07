# Migrate Metadata TO Mongo for Rivendell push
echo "usage: load-migration2.1-rivendell.sh <den username> <den password>"
echo "Rivendell Push loading script."

# Log into Dendra
den login $1 $2 

# Basics - these don't change much
den meta push-schemes --filespec=../data/migration2-happyhybrid/scheme/* 
den meta push-schemes --filespec=../data/migration2.1-rivendell/scheme/* 

den meta push-soms --filespec=../data/migration2-happyhybrid/som/* 
den meta push-soms --filespec=../data/migration2.1-rivendell/som/* 

den meta push-uoms --filespec=../data/migration2-happyhybrid/uom/* 
den meta push-uoms --filespec=../data/migration2.1-rivendell/uom/* 

den meta push-places --filespec=../data/migration2-happyhybrid/place/* 

# organizations are hand created and should not be pulled from MySQL
den meta push-organizations --filespec=../data/migration2-happyhybrid/organization/* 

# vocabulary
den meta push-vocabularies --filespec=../data/migration2-happyhybrid/vocabulary/* 
den meta push-vocabularies --filespec=../data/migration2.1-rivendell/vocabulary/* 

# dashboards
den meta push-dashboards --filespec=../data/migration2-happyhybrid/dashboard/* 
den meta push-dashboards --filespec=../data/migration2.1-rivendell/dashboard/*  

# stations
#den meta push-stations --filespec=../data/migration2-happyhybrid/station/* 
den meta push-stations --save --filespec=../data/migration2.1-rivendell/station/* 

# datastreams
den meta push-datastreams --filespec=../data/migration2-happyhybrid/datastream/* 
den meta push-datastreams --save --filespec=../data/migration2.1-rivendell/datastream/*

echo "RIVENDELL MIGRATION LOADED!" 
