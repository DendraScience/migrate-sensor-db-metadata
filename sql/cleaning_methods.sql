-- SQL Export of Methods to Thing Types
-- Collin Bode
-- 2019-03-11
-- 

mysql> desc methods;
+-------------------+---------------------+------+-----+---------+----------------+
| Field             | Type                | Null | Key | Default | Extra          |
+-------------------+---------------------+------+-----+---------+----------------+
| MethodID          | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| MethodName        | varchar(255)        | NO   | UNI | NULL    |                |
| MethodDescription | text                | YES  |     | NULL    |                |
| MethodLink        | text                | YES  |     | NULL    |                |
mysql> desc datastreams;
| VariableCode        | varchar(50)          | NO   | MUL | NULL    |                |
| VariableID          | smallint(5) unsigned | NO   | MUL | NULL    |                |
| MethodName          | varchar(255)         | NO   | MUL | NULL    |                |
| MethodID            | smallint(5) unsigned | NO   | MUL | NULL    |                |
| DeviceName          | varchar(255)         | YES  |     | NULL    |                |

| RangeMin            | decimal(8,2)         | YES  |     | NULL    |                |
| RangeMax            | decimal(8,2)         | YES  |     | NULL    |                |
+---------------------+----------------------+------+-----+---------+----------------+
24 rows in set (0.00 sec)

-- SQL TEMPLATE
SELECT 
FROM
WHERE
AND
ORDER BY

-- UCNRS cleaning required. Air Temp and Rain gage temp were both listed as wind speed

-- Change method from Wind sensor back to HMP50 temp/rh
SELECT datastreamid, datastreamname, variablecode, variableid, devicename, rangemin, rangemax 
FROM datastreams WHERE methodid = 18 AND variablecode LIKE "Air Temp C%" ORDER BY datastreamid;
38 rows in set (0.00 sec)

UPDATE datastreams SET methodid = 79 WHERE methodid = 18 AND variablecode LIKE 
"Air Temp C%";
Query OK, 38 rows affected (0.00 sec)
Rows matched: 38  Changed: 38  Warnings: 0

-- Change method from Wind Sensor back to Rain Gage
SELECT datastreamid, datastreamname, variablecode, variableid, devicename, rangemin, rangemax 
FROM datastreams WHERE methodid = 18 AND variablecode LIKE "Rain Gauge Temp C" ORDER BY datastreamid;
19 rows in set (0.00 sec)

SELECT datastreamid, datastreamname, variablecode, variableid, devicename, rangemin, rangemax, methodid, methodname FROM datastreams WHERE datastreamid = 3350;

| datastreamid | datastreamname           | variablecode | variableid | devicename | rangemin | rangemax | methodid | methodname      |
+--------------+--------------------------+--------------+------------+------------+----------+----------+----------+-----------------+
|         3350 | Precipitation mm Angelo  | Rainfall mm  |         35 | NULL       |     0.00 |   500.00 |       83 | TB4-L Rain Gage |

UPDATE datastreams SET methodid = 83 WHERE methodid = 18 AND variablecode LIKE "Rain Gauge Temp C";
Query OK, 19 rows affected (0.00 sec)
Rows matched: 19  Changed: 19  Warnings: 0



