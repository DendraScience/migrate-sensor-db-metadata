# MySQL table loader bash script
user=$1
pass=$2
org=$3

echo "usage: load_all_tables <user> <password> <organization-slug>"

# Load organization table first
# Update which organization should be extracted
# Create table with monitoring collection mapping to organizations
echo mysql -p -u $user odm < ../sql/create-table/dendra_map_monitoring_collections_organizations.sql
mysql -p$pass -u$user odm < ../sql/create-table/dendra_map_monitoring_collections_organizations.sql

# Update table with the organization to be extracted
org_update="UPDATE dendra_map_mcollections_organizations SET transfer_metadata = 1 WHERE slug = '$org';"
echo $org_update
echo $org_update | mysql -p$pass -u$user odm

SQLfiles="../sql/create-table/dendra_map_stations_media.sql
../sql/create-table/dendra_map_variablecodes_tags.sql
../sql/create-view/vw_sites_stations.sql
../sql/create-view/vw_export_stations.sql
../sql/create-view/vw_export_datastreams.sql"

for sqlfile in $SQLfiles
do
	echo "mysql -p -u $user odm < "$sqlfile
	mysql -p$pass -u$user odm < $sqlfile
done
echo "DONE!"
