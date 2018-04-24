# Export script for views from MySQL
host=$1
user=$2
pass=$3
exportdir=$4

echo "extract-sensordb-export-sql-views: output directory $exportdir"
echo "extract-sensordb-export-sql-views: make sure VPN is active or connection to Gall will fail."
if [ -d $exportdir ]
then 
	echo "exporting vw_export_datastreams"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_stations --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"station/"{slug}.station.json
	echo "exporting vw_export_stations"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_datastreams --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{tags.0}.{tags.1}.{external_refs.0.identifier}.datastream.json
else
	echo "$exportdir not a directory."
fi
