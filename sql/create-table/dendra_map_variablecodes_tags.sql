-- MySQL dump 10.16  Distrib 10.2.11-MariaDB, for osx10.13 (x86_64)
--
-- Host: localhost    Database: odm
-- ------------------------------------------------------
-- Server version	10.2.11-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dendra_map_variablecodes_tags`
--

DROP TABLE IF EXISTS `dendra_map_variablecodes_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dendra_map_variablecodes_tags` (
  `VariableCode` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Medium` varchar(255) NOT NULL,
  `Variable` varchar(255) NOT NULL,
  `Unit` varchar(255) NOT NULL,
  `Aggregate` varchar(255) DEFAULT NULL,
  `Misc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`VariableCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dendra_map_variablecodes_tags`
--

LOCK TABLES `dendra_map_variablecodes_tags` WRITE;
/*!40000 ALTER TABLE `dendra_map_variablecodes_tags` DISABLE KEYS */;
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp C','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp C Avg','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp C Max','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp C Min','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp Delta C Avg','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp Delta C Max','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Air Temp Delta C Min','ds_Medium_Air','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Barometric Pressure mb','ds_Medium_Air','ds_Variable_BarometricPressure','dt_Unit_Millibar','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Barometric Pressure mmHg ','ds_Medium_Air','ds_Variable_BarometricPressure','dt_Unit_MillimeterOfMercury','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Battery Voltage','ds_Medium_Battery','ds_Variable_Voltage','dt_Unit_Volt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Battery Voltage Avg','ds_Medium_Battery','ds_Variable_Voltage','dt_Unit_Volt','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Battery Voltage Max','ds_Medium_Battery','ds_Variable_Voltage','dt_Unit_Volt','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Battery Voltage Min','ds_Medium_Battery','ds_Variable_Voltage','dt_Unit_Volt','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('CO2 Concentration ppm/10','ds_Medium_Air','ds_Variable_Concentration','dt_Unit_PartPerMillion',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Derived Cumulative Precipitation','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Millimeter','ds_Aggregate_Cumulative',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Dielectric','ds_Medium_Rock','ds_Variable_DielectricStrength','dt_Unit_Dimensionless',NULL,'sqrt(dielectric constant)');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Discharge','ds_Medium_SurfaceWater','ds_Variable_Discharge','dt_Unit_CubicMeterPerSecond',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Electrical Conductivity dS/m','ds_Medium_Rock','ds_Variable_Moisture','dt_Unit_DecisiemenPerMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Electrical Current mA','ds_Medium_Not Applicable','ds_Variable_ElectricCurrent','dt_Unit_Milliamp',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Evapotranspiration','ds_Medium_Air','ds_Variable_Evapotranspiration','dt_Unit_Millimeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('External Voltage','ds_Medium_Instrument','ds_Variable_Voltage','dt_Unit_Volt',NULL,'external');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Forward Power','ds_Medium_Instrument','ds_Variable_RadioTransmission','dt_Unit_DecibelMilliwatt',NULL,'forward');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Fuel Moisture Per Avg','ds_Medium_Instrument','ds_Variable_Moisture','dt_Unit_Percent','ds_Aggregate_Average','"instrument":"fuel"');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Gage Height meters','ds_Medium_SurfaceWater','ds_Variable_Depth','dt_Unit_Meter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('GEONOR GAUGE FREQ hz','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Hertz',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('GEONOR PRECIP cm','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Centimeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Hail Cumulative mm','ds_Medium_Snow','ds_Variable_Height','dt_Unit_Millimeter','ds_Aggregate_Cumulative',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Hail Intensity mm/h','ds_Medium_Snow','ds_Variable_Height','dt_Unit_MillimeterPerHour',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Instrument Temp C','ds_Medium_Instrument','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Leaf Wetness cnts mV','ds_Medium_Leaf','ds_Variable_Moisture','dt_Unit_Count',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Leaf Wetness Excitation mV','ds_Medium_Leaf','ds_Variable_Moisture','dt_Unit_Millivolt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Leaf Wetness kohms','ds_Medium_Leaf','ds_Variable_Moisture','dt_Unit_Kiloohm',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Leaf Wetness Minutes','ds_Medium_Leaf','ds_Variable_Moisture','dt_Unit_MinuteTime',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Leaf Wetness Percent','ds_Medium_Leaf','ds_Variable_Moisture','dt_Unit_Percent',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Logger Temp c','ds_Medium_Instrument','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Logger Voltage V','ds_Medium_Instrument','ds_Variable_Voltage','dt_Unit_Volt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Par Instant lux','ds_Medium_Solar','ds_Variable_PhotosyntheticallyActiveRadiation','dt_Unit_Lux',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('PAR umole Avg','ds_Medium_Solar','ds_Variable_PhotosyntheticallyActiveRadiation','dt_Unit_MicromolePerSquareMeter','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('PAR umole Max','ds_Medium_Solar','ds_Variable_PhotosyntheticallyActiveRadiation','dt_Unit_MicromolePerSquareMeter','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('PAR umole Min','ds_Medium_Solar','ds_Variable_PhotosyntheticallyActiveRadiation','dt_Unit_MicromolePerSquareMeter','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('PAR umole','ds_Medium_Solar','ds_Variable_PhotosyntheticallyActiveRadiation','dt_Unit_MicromolePerSquareMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('VWC Period uSec','ds_Medium_Soil','ds_Variable_Moisture','dt_Unit_Microsecond','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Radio Signal Strength dB','ds_Medium_Instrument','ds_Variable_RadioTransmission','dt_Unit_Decibel',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rain Gauge Temp C','ds_Medium_Instrument','ds_Variable_Temperature','dt_Unit_DegreeCelsius',NULL,'gauge');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall Cumulative cm','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Centimeter','ds_Aggregate_Cumulative',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall Cumulative in.','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Inch','ds_Aggregate_Cumulative',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall Cumulative mm','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Millimeter','ds_Aggregate_Cumulative',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall inches','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Inch',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall Intensity mm/h','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_MillimeterPerHour',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall mm','ds_Medium_Precipitation','ds_Variable_Height','dt_Unit_Millimeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall Raw Hz','ds_Medium_Precipitation','ds_Variable_Precipitation','dt_Unit_Hertz',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rainfall Raw Std Dev Hz','ds_Medium_Precipitation','ds_Variable_Precipitation','dt_Unit_Hertz','ds_Aggregate_StandardDeviation',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Raw Sensor Response','ds_Medium_Not Applicable','ds_Variable_Unknown','dt_Unit_Dimensionless',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Reflected Power','ds_Medium_Instrument','ds_Variable_RadioTransmission','dt_Unit_DecibelMilliwatt',NULL,'reflected');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rel Humidity Per Avg','ds_Medium_Air','ds_Variable_RelativeHumidity','dt_Unit_Percent','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rel Humidity Per Max','ds_Medium_Air','ds_Variable_RelativeHumidity','dt_Unit_Percent','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rel Humidity Per Min','ds_Medium_Air','ds_Variable_RelativeHumidity','dt_Unit_Percent','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rel Humidity Perc','ds_Medium_Air','ds_Variable_RelativeHumidity','dt_Unit_Percent',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Resistance','ds_Medium_Rock','ds_Variable_Moisture','dt_Unit_Kiloohm',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rock Moisture Percent','ds_Medium_Rock','ds_Variable_Moisture','dt_Unit_Percent',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Rock Temperature C','ds_Medium_Rock','ds_Variable_Temperature','dt_Unit_DegreeCelsius',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sap Flow cm/hr','ds_Medium_Sap','ds_Variable_Flux','dt_Unit_CentimeterPerHour',NULL,'sap');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sap Flow mV','ds_Medium_Sap','ds_Variable_Flux','dt_Unit_Millivolt',NULL,'sap');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sky Quality','ds_Medium_Sky','ds_Variable_Visibility','dt_Unit_MagnitudesperSquareArcsecond',NULL,'"instrument":"sky"');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sky Quality Avg','ds_Medium_Sky','ds_Variable_Visibility','dt_Unit_MagnitudesperSquareArcsecond','ds_Aggregate_Average','sky');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sky Quality Max','ds_Medium_Sky','ds_Variable_Visibility','dt_Unit_MagnitudesperSquareArcsecond','ds_Aggregate_Maximum','sky');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sky Quality Min','ds_Medium_Sky','ds_Variable_Visibility','dt_Unit_MagnitudesperSquareArcsecond','ds_Aggregate_Minimum','sky');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Depth cm','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Centimeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Depth in.','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Inch',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Depth Meters','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Meter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Depth mm','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Millimeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Depth mv','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Millivolt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Depth Signal Quality','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Dimensionless',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Temp Deg C Avg','ds_Medium_Snow','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Temp Deg C Max','ds_Medium_Snow','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow Temp Deg C Min','ds_Medium_Snow','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Snow-water equivalent inches','ds_Medium_Snow','ds_Variable_Depth','dt_Unit_Inch',NULL,'water equivalent');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Conductivity Avg S/m','ds_Medium_Soil','ds_Variable_ElectricalConductivity','dt_Unit_SiemenPerMeter','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Moisture cbar','ds_Medium_Soil','ds_Variable_Moisture','dt_Unit_Centibar',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Moisture mV','ds_Medium_Soil','ds_Variable_Moisture','dt_Unit_Millivolt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Moisture Pct','ds_Medium_Soil','ds_Variable_Moisture','dt_Unit_Percent','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Moisture Pct Avg','ds_Medium_Soil','ds_Variable_Moisture','dt_Unit_Percent','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Moisture Volts','ds_Medium_Soil','ds_Variable_Moisture','dt_Unit_Volt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Temp C Avg','ds_Medium_Soil','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Temp C Max','ds_Medium_Soil','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Temp C Min','ds_Medium_Soil','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Temperature C','ds_Medium_Soil','ds_Variable_Temperature','dt_Unit_DegreeCelsius',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Soil Temperature Volts','ds_Medium_Soil','ds_Variable_Temperature','dt_Unit_Volt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Panel Voltage V','ds_Medium_Instrument','ds_Variable_Radiation','dt_Unit_Volt',NULL,'solar panel');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Avg W/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_WattPerSquareMeter','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Clear-Sky MJ/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_MegajoulePerSquareMeter',NULL,'clear sky');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Max W/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_WattPerSquareMeter','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Min W/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_WattPerSquareMeter','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Net W/m^2','ds_Medium_Solar','ds_Variable_NetRadiation','dt_Unit_WattPerSquareMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Std W/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_WattPerSquareMeter','ds_Aggregate_StandardDeviation',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Total kJ/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_KilojoulePerSquareMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Total kW/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_KilojoulePerSquareMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Total lux','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_Lux',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Total MJ/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_MegajoulePerSquareMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Radiation Total W/m^2','ds_Medium_Solar','ds_Variable_Radiation','dt_Unit_WattPerSquareMeter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Solar Voltage','ds_Medium_Instrument','ds_Variable_Radiation','dt_Unit_Volt',NULL,'solar panel');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Turbidity NTU','ds_Medium_SurfaceWater','ds_Variable_Turbidity','dt_Unit_NephelometricTurbidityUnit',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Unknown','ds_Medium_Unknown','ds_Variable_Unknown','dt_Unit_Dimensionless',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Water Level m','ds_Medium_GroundWater','ds_Variable_Depth','dt_Unit_Meter',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Water Level Manual m','ds_Medium_GroundWater','ds_Variable_Depth','dt_Unit_Meter',NULL,'manual');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Water Pressure mbar','ds_Medium_Water','ds_Variable_Pressure','dt_Unit_Millibar',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Water Pressure mV','ds_Medium_Water','ds_Variable_Pressure','dt_Unit_Millivolt',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Water Pressure psi','ds_Medium_Water','ds_Variable_Pressure','dt_Unit_PoundForcePerSquareInch',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Water Temp C','ds_Medium_Water','ds_Variable_Temperature','dt_Unit_DegreeCelsius',NULL,NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Direction Degrees','ds_Medium_Air','ds_Variable_Direction','dt_Unit_DegreeAngle','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Direction Standard Deviation','ds_Medium_Air','ds_Variable_Direction','dt_Unit_DegreeAngle','ds_Aggregate_StandardDeviation',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Gust MS','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Avg MPH','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MilePerHour','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Avg MS','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond','ds_Aggregate_Average',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Max MPH','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MilePerHour','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Max MS','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond','ds_Aggregate_Maximum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Min MPH','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MilePerHour','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Min MS','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond','ds_Aggregate_Minimum',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Stdev MPH','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MilePerHour','ds_Aggregate_StandardDeviation',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Speed Stdev MS','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond','ds_Aggregate_StandardDeviation',NULL);
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Vector Magnitude MS','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond',NULL,'vector');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Wind Vector Speed m s','ds_Medium_Air','ds_Variable_Speed','dt_Unit_MeterPerSecond',NULL,'vector');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Sap Heat Diffusion Difference C','ds_Medium_Sap','ds_Variable_Temperature','dt_Unit_DegreeCelsius','ds_Aggregate_Average','difference');
INSERT INTO `dendra_map_variablecodes_tags` VALUES ('Voltage Regulator V Min','ds_Medium_Instrument','ds_Variable_Voltage','dt_Unit_Volt','ds_Aggregate_Minimum',NULL);

/*!40000 ALTER TABLE `dendra_map_variablecodes_tags` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-02-08  9:15:31
