# Migrate Sensor DB Metadata to Dendra

Contains scripts and tools to migrate metadata from the Berkeley Sensor Database to Dendra.


## About
- The `sql` folder contains scripts for creating mapping tables and "export" views in the sensor database.  
- The `tools` folder contains helper scripts that can be used to load the JSON in the `data` folder.  This requires the [Dendra CLI](https://github.com/DendraScience/dendra-cli) executable.  
- The `data` folder contains exported and static JSON.  There are several migrations, or versions, of the data.  
> -- `migration-round1`: "Preview" original JSON created by Collin Bode's python scripts for UCNRS and the preview dashboard.  
> -- `migration-round2`: "Happy Hybrid" added Quail Ridge weather station as the first end-to-end station managed entirely in Dendra.  This round maintains compatibility with the original Preview edition of the dashboard, including unit errors (mile, not miles and intolerance of Kilowatts instead of watts).    
> -- `migration-round3`: "Rivendell" breaks the old Preview dashboard, uses the next version of the API.  Major changes in schema, naming conventions.  Brings the new multi-station dashboard online, allowing Rivendell, the field site for the [Eel River CZO](http://criticalzone.org/eel/) to be viewed for the first time.    

## Round3 "Rivendell" Changes
- 'Variables' renamed to 'Measurements'.  
- 'Seasonal' derived values renamed to 'Climate'.    
- Vocabularies are redesigned to allow relationships between values.   
- Compatability errors left in 'Happy Hybrid' are corrected.  
