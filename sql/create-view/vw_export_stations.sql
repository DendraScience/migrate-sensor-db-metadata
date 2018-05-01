CREATE OR REPLACE VIEW `vw_export_stations` AS
SELECT

  -- ----------------------------
  -- "activated_at": "2017-05-28T09:50:23.106Z",

  -- ----------------------------
  -- "deactivated_at": "2017-05-28T09:50:23.106Z",

  -- ----------------------------
  -- "description": "station is mid-slope at Rivendell research site.  Primarily for wells and soil moisture. Has four enclosures for TDRs.",
  -- NOT IN SCHEMA YET 
  -- CONCAT(stations_comments,"\n",sites_comments) as `description`,

  -- ----------------------------
  -- "enabled": true,

  "true" AS `enabled`,

  -- ----------------------------
  -- "external_links": [
  --   {
  --     "title": "Sensor database",
  --     "url": "http://sensor.berkeley.edu/index_ucnrs.html"
  --   }
  -- ],
  "Metadata" AS `external_links$0$title`,
  `vw_sites_stations`.`url` AS `external_links$0$url`,

  -- WRCC DRI website for UCNRS only 
  IF(`vw_sites_stations`.`organization_id` = "58db17c424dc720001671378", 
    "Original Site", NULL) 
    AS `external_links$1$title`,
  IF(`vw_sites_stations`.`organization_id` = "58db17c424dc720001671378", 
    CONCAT("https://wrcc.dri.edu/weather/",(SELECT substring(`vw_sites_stations`.`FileName`,1,4)),".html"), NULL)  
    AS `external_links$1$url`,

  -- ----------------------------
  -- "external_refs": [
  --   {
  --     "identifier": "334",
  --     "type": "odm.stations.stationid",
  --     "url": "http://sensor.berkeley.edu/index_ucnrs.html"
  --   }
  -- ],

  CAST(`vw_sites_stations`.`StationID` AS CHAR(50)) AS `external_refs$0$identifier`,
  'odm.station.StationID' AS `external_refs$0$type`,
  CONCAT('file://', `vw_sites_stations`.`FileName`) AS `external_refs$0$url`,

  -- ----------------------------
  -- "full_name": "Blue Oak Ranch Reserve Weather Station",

  -- ----------------------------
  -- "geo": {
  --   "coordinates": [
  --     -121.73638,
  --     37.381666,
  --     574.548
  --   ],
  --   "type": "Point"
  -- },

  `vw_sites_stations`.`Longitude` AS `geo$coordinates$0`,
  `vw_sites_stations`.`Latitude` AS `geo$coordinates$1`,
  `vw_sites_stations`.`Elevation_m` AS `geo$coordinates$2`,
  'Point' AS `geo$type`,

  -- ----------------------------
  -- "is_active": true,

  "true" AS `is_active`,

  -- ----------------------------
  -- "is_stationary": true,

  "true" AS `is_stationary`,

  -- ----------------------------
  -- "media": [
  --   {
  --     "type": "photo",
  --     "sizes": {
  --       "thumb": {
  --         "h": 60,
  --         "w": 60,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_60,w_60/photo.jpg"
  --       },
  --       "thumb_2x": {
  --         "h": 120,
  --         "w": 120,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_120,w_120/photo.jpg"
  --       },
  --       "small": {
  --         "h": 240,
  --         "w": 240,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_240,w_240/photo.jpg"
  --       },
  --       "small_2x": {
  --         "h": 480,
  --         "w": 480,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_480,w_480/photo.jpg"
  --       },
  --       "medium": {
  --         "h": 480,
  --         "w": 480,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_480,w_480/photo.jpg"
  --       },
  --       "medium_2x": {
  --         "h": 960,
  --         "w": 960,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_960,w_960/photo.jpg"
  --       },
  --       "large": {
  --         "h": 1080,
  --         "w": 1080,
  --         "url": "http://res.cloudinary.com/dendro/image/upload/c_fill,g_center,h_1080,w_1080/photo.jpg"
  --       }
  --     }
  --   }
  -- ],

  -- "media": [0]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 0) AS `media$0$sizes$large$url`,

  -- "media": [1]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 1) AS `media$1$sizes$large$url`,

  -- "media": [2]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 2) AS `media$2$sizes$large$url`,

  -- "media": [3]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 3) AS `media$3$sizes$large$url`,

  -- "media": [4]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 4) AS `media$4$sizes$large$url`,

  -- "media": [5]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 5) AS `media$5$sizes$large$url`,

  -- "media": [6]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 6) AS `media$6$sizes$large$url`,

  -- "media": [7]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 7) AS `media$7$sizes$large$url`,

  -- "media": [8]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 8) AS `media$8$sizes$large$url`,

  -- "media": [9]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 9) AS `media$9$sizes$large$url`,

  -- "media": [10]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 10) AS `media$10$sizes$large$url`,

  -- "media": [11]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 11) AS `media$11$sizes$large$url`,

  -- "media": [12]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 12) AS `media$12$sizes$large$url`,

  -- "media": [13]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 13) AS `media$13$sizes$large$url`,

  -- "media": [14]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 14) AS `media$14$sizes$large$url`,

  -- "media": [15]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 15) AS `media$15$sizes$large$url`,

  -- "media": [16]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 16) AS `media$16$sizes$large$url`,

  -- "media": [17]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 17) AS `media$17$sizes$large$url`,

  -- "media": [18]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 18) AS `media$18$sizes$large$url`,

  -- "media": [19]

  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$type`,
  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$thumb$h`,
  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$thumb$w`,
  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$thumb$url`,
  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$thumb2x$h`,
  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$thumb2x$w`,
  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$thumb2x$url`,
  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$small$h`,
  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$small$w`,
  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$small$url`,
  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$small2x$h`,
  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$small2x$w`,
  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$small2x$url`,
  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$medium$h`,
  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$medium$w`,
  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$medium$url`,
  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$medium2x$h`,
  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$medium2x$w`,
  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$medium2x$url`,
  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$large$h`,
  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$large$w`,
  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET 19) AS `media$19$sizes$large$url`,

  -- ----------------------------
  -- "members": [
  --   {
  --     "organization_id": "592f155746a1b867a114e030",
  --     "roles": [
  --       "contact"
  --     ]
  --   },
  --   {
  --     "person_id": "592f155746a1b867a114e040",
  --     "roles": [
  --       "admin",
  --       "contact"
  --     ]
  --   }
  -- ],

  -- ----------------------------
  -- "name": "Blue Oak Ranch",

  `vw_sites_stations`.`StationName` AS `name`,

  -- ----------------------------
  -- "organization_id": "592f155746a1b867a114e030",

  `vw_sites_stations`.`organization_id` AS `organization_id`,
  -- `vw_sites_stations`.`organization_slug` AS `organization_slug`,  

  -- ----------------------------
  -- "place_id": "592f155746a1b867a114e050",

  -- ----------------------------
  -- "slug": "blue-oak-ranch",
  LOWER(REPLACE(REPLACE(`vw_sites_stations`.`StationName`,' ','-'),'_',''))  AS `slug`,

  -- ----------------------------
  -- "station_type": "weather",

  'weather' AS `station_type`,

  -- ----------------------------
  -- "thing_ids": [
  --   "592f155746a1b867a114e070"
  -- ],

  -- ----------------------------
  -- "time_zone": "PST",

  'PST' AS `time_zone`,

  -- ----------------------------
  -- "utc_offset": -28800

  -28800 AS `utc_offset`

FROM `vw_sites_stations`
--  INNER JOIN `dendra_map_stations_media` ON `vw_sites_stations`.`StationID` = (SELECT StationID FROM dendra_map_stations_media)
WHERE `transfer_metadata` = 1 
;
