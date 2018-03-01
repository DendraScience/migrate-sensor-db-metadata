# MySQL table loader bash script
user=$1
pass=$2

echo "usage: load_all_tables <user> <password>"

SQLfiles="../sql/create-table/dendra_map_monitoring_collections_organizations.sql 
../sql/create-table/dendra_map_stations_media.sql
../sql/create-table/dendra_map_variablecodes_pre.sql
../sql/create-table/dendra_map_variables_tags.sql
../sql/create-view/vw_sites_stations.sql
../sql/create-view/vw_export_stations.sql
../sql/create-view/vw_export_datastreams.sql"

for sqlfile in $SQLfiles
do
	#echo $sqlfile
	echo "mysql -p -u $user odm < "$sqlfile
	mysql -p$pass -u $user odm < $sqlfile
done
echo "DONE!"
