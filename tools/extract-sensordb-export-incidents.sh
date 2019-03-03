# Export script for views from MySQL
# Note: export goes into compost.  These are intermediate files.
# After this is run, the following is required: transform-sensordb-incident2annotation.js
# 
host=$1
user=$2
pass=$3

exportdir="../compost/migration3-incidents/"

echo "extract-sensordb-export-incidents: output directory $exportdir"
echo "extract-sensordb-export-incidents: make sure VPN is active or connection to Gall will fail."
if [ -d $exportdir ]
then 
	echo "exporting vw_export_incident"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_incident_erczo --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"erczo/annotation/"{IncidentID}.annotation.json
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_incident_ucnrs --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"ucnrs/annotation/"{IncidentID}.annotation.json
else
	echo "$exportdir not a directory."
fi
 