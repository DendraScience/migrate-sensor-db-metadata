# Export script for views from MySQL
host=$1
user=$2
pass=$3
exportdir=$4

echo "extract-sensordb-export-sql-views: output directory $exportdir"
echo "extract-sensordb-export-sql-views: make sure VPN is active or connection to Gall will fail."
if [ -d $exportdir ]
then 
	echo "exporting vw_export_stations"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_stations --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"station/"{slug}.station.json
	echo "exporting vw_export_datastreams"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_datastreams --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{name}.datastream.json
	echo "exporting vw_export_datastreams_seasonal_avg"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_datastreams_seasonal_avg --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{name}.avg.seasonal.datastream.json
	echo "exporting vw_export_datastreams_seasonal_min"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_datastreams_seasonal_min --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{name}.min.seasonal.datastream.json
	echo "exporting vw_export_datastreams_seasonal_max"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_datastreams_seasonal_max --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{name}.max.seasonal.datastream.json
	echo "exporting vw_export_datastreams_seasonal_sum"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_datastreams_seasonal_sum --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"datastream/"{name}.sum.seasonal.datastream.json
else
	echo "$exportdir not a directory."
fi
