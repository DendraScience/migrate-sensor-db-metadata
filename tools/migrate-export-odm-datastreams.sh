# Export script for datastreams from MySQL
exportdir=$1
echo "export-odm-stations.sh will attempt to export vw_export_datastreams to the existing directory: $1"
if [ -d $exportdir ]
then 
	mysql-export-json multi --conn:database=odm --conn:user=collin --conn:password=river --merge=ltr --exp:tableName=vw_export_datastreams --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir/{tags.0}.{tags.1}.{external_refs.0.identifier}.datastream.json
else
	echo "$exportdir not a directory."
fi