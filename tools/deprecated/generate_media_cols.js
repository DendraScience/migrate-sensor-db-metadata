for (let i = 0; i < 20; i++) {
  const lines = [
    '',
    '  -- "media": [' + i + ']',
    '',
    "  (SELECT media_type FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$type`,",
    "  (SELECT thumb_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$thumb$h`,",
    "  (SELECT thumb_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$thumb$w`,",
    "  (SELECT thumb_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$thumb$url`,",
    "  (SELECT thumb2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$thumb2x$h`,",
    "  (SELECT thumb2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$thumb2x$w`,",
    "  (SELECT thumb2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$thumb2x$url`,",
    "  (SELECT small_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$small$h`,",
    "  (SELECT small_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$small$w`,",
    "  (SELECT small_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$small$url`,",
    "  (SELECT small2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$small2x$h`,",
    "  (SELECT small2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$small2x$w`,",
    "  (SELECT small2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$small2x$url`,",
    "  (SELECT medium_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$medium$h`,",
    "  (SELECT medium_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$medium$w`,",
    "  (SELECT medium_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$medium$url`,",
    "  (SELECT medium2x_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$medium2x$h`,",
    "  (SELECT medium2x_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$medium2x$w`,",
    "  (SELECT medium2x_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$medium2x$url`,",
    "  (SELECT large_h FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$large$h`,",
    "  (SELECT large_w FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$large$w`,",
    "  (SELECT large_url FROM dendra_map_stations_media WHERE `StationID` = `vw_sites_stations`.`StationID` ORDER BY seq ASC LIMIT 1 OFFSET " + i + ") AS `media$" + i + "$sizes$large$url`,"
  ]

  console.log(lines.join('\r\n'))
}
