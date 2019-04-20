# extract methods to thing types
# requires further post processing 
# starts in compost 

# Export script for views from MySQL
pass=$1
user=collin
host="gall.berkeley.edu" # "gall.berkeley.edu" # "localhost"
exportdir="../compost/migration4-methods/"

echo "extract-sensordb-export-methods: output directory $exportdir"
echo "extract-sensordb-export-methods: make sure VPN is active or connection to Gall will fail."
if [ -d $exportdir ]
then 
	echo "exporting vw_export_methods"
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=methods --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"method/mid."{MethodID}.method.json
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_methods --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"method_variable/mid."{methodid}.vid.{variableid}.methodvariable.json
	mysql-export-json multi --conn:host=$host --conn:database=odm --conn:user=$user --conn:password=$pass --merge=ltr --exp:tableName=vw_export_devices --exp:dotSeparator=%24 --exp:expand --exp:convertTrueFalse --filetmpl=$exportdir"device/devid."{DeviceID}.dsid.{DatastreamID}.device.json
else
	echo "$exportdir not a directory."
fi
