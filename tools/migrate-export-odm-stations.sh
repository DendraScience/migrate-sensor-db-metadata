# Export script for stations from MySQL
exportdir=$1
echo "export-odm-stations.sh will attempt to export vw_export_stations to the existing directory: $1"
if [ -d $exportdir ]
then 
	echo "exporting vw_export_datastreams"
	mysql-export-json multi --conn:database=odm --conn:user=collin --conn:password=river --merge=ltr --exp:tableName=vw_export_stations --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir/{slug}.station.json
else
	echo "$exportdir not a directory."
fi