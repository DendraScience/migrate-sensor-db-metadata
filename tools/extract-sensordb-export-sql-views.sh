# Export script for views from MySQL
exportdir=$1
echo "extract-sensordb-export-sql-views: output directory $1"
if [ -d $exportdir ]
then 
	echo "exporting vw_export_datastreams"
	mysql-export-json multi --conn:database=odm --conn:user=collin --conn:password=river --merge=ltr --exp:tableName=vw_export_stations --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"station/"{slug}.station.json
	echo "exporting vw_export_stations"
	mysql-export-json multi --conn:database=odm --conn:user=collin --conn:password=river --merge=ltr --exp:tableName=vw_export_datastreams --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{tags.0}.{tags.1}.{external_refs.0.identifier}.datastream.json
else
	echo "$exportdir not a directory."
fi
