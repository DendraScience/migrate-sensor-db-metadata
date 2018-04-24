# MySQL table loader bash script
host=$1
user=$2
pass=$3
org=$4

echo "usage: load_all_tables <user> <password> <organization-slug>"

# Load organization table first
# Update which organization should be extracted
# Create table with monitoring collection mapping to organizations
echo mysql --host=$host -p -u $user odm < ../sql/create-table/dendra_map_monitoring_collections_organizations.sql
mysql --host=$host -p$pass -u$user odm < ../sql/create-table/dendra_map_monitoring_collections_organizations.sql

# Update table with the organization to be extracted
org_update="UPDATE dendra_map_mcollections_organizations SET transfer_metadata = 1 WHERE slug = '$org';"
echo $org_update
echo $org_update | mysql --host=$host -p$pass -u$user odm

SQLfiles="../sql/create-table/dendra_map_stations_media.sql
../sql/create-table/dendra_map_datastreams_attributes.sql
../sql/create-table/dendra_map_variablecodes_tags.sql
../sql/create-view/vw_sites_stations.sql
../sql/create-view/vw_export_stations.sql
../sql/create-view/vw_export_datastreams.sql"

for sqlfile in $SQLfiles
do
	echo "mysql --host=$host -p -u $user odm < "$sqlfile
	mysql --host=$host -p$pass -u$user odm < $sqlfile
done
echo "DONE!"
