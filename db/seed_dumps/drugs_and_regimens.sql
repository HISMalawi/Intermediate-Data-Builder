-- MySQL dump 10.13  Distrib 5.7.29, for Linux (x86_64)
--
-- Host: localhost    Database: ids_small_site
-- ------------------------------------------------------
-- Server version	5.7.29-0ubuntu0.18.04.1

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
-- Table structure for table `arv_drugs`
--

DROP TABLE IF EXISTS `arv_drugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arv_drugs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `drug_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arv_drugs`
--

LOCK TABLES `arv_drugs` WRITE;
/*!40000 ALTER TABLE `arv_drugs` DISABLE KEYS */;
INSERT INTO `arv_drugs` VALUES (1,5,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(2,6,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(3,31,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(4,32,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(5,95,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(6,41,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(7,42,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(8,177,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(9,957,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(10,39,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(11,89,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(12,736,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(13,984,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(14,21,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(15,22,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(16,817,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(17,968,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(18,971,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(19,11,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(20,28,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(21,29,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(22,30,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(23,951,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(24,2,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(25,3,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(26,72,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(27,104,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(28,613,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(29,730,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(30,813,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(31,23,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(32,73,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(33,74,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(34,94,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(35,739,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(36,9,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(37,10,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(38,36,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(39,37,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(40,38,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(41,14,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(42,40,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(43,614,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(44,731,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(45,732,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(46,955,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(47,70,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(48,71,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(49,90,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(50,91,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(51,737,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(52,738,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(53,735,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(54,815,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(55,816,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(56,733,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(57,969,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(58,734,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(59,814,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(60,932,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(61,933,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(62,934,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(63,952,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(64,954,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(65,976,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(66,977,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(67,978,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(68,979,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(69,983,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(70,980,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(71,981,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(72,982,'0000-00-00 00:00:00','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `arv_drugs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medication_regimen`
--

DROP TABLE IF EXISTS `medication_regimen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medication_regimen` (
  `medication_regimen_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `regimen` varchar(255) DEFAULT NULL,
  `drug_composition` varchar(255) DEFAULT NULL,
  `voided` tinyint(1) NOT NULL DEFAULT '0',
  `voided_by` bigint(20) DEFAULT NULL,
  `voided_date` datetime DEFAULT NULL,
  `void_reason` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`medication_regimen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medication_regimen`
--

LOCK TABLES `medication_regimen` WRITE;
/*!40000 ALTER TABLE `medication_regimen` DISABLE KEYS */;
INSERT INTO `medication_regimen` VALUES (1,'0A','22,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(2,'0P','733,968',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(3,'0P','22,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(4,'0P','969,968',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(5,'0P','968,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(6,'0P','22,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(7,'10A','73,734',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(8,'11A','39,73',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(9,'11P','74,736',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(10,'11P','73,736',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(11,'11P','39,74',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(12,'11P','736,979',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(13,'11P','736,1045',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(14,'12A','976,977,982',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(15,'13A','983',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(16,'13A','734,982',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(17,'13A','982,983',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(18,'14A','982,984',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(19,'14P','736,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(20,'15A','982,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(21,'15P','982,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(22,'15P','981,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(23,'15P','980,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(24,'15P','982,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(25,'15P','981,981',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(26,'15P','980,980',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(27,'16A','954,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(28,'16P','1043,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(29,'16P','954,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(30,'16P','954,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(31,'17A','11,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(32,'17P','30,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(33,'17P','30,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(34,'17P','733,954',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(35,'17P','29,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(36,'17P','28,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(37,'17P','11,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(38,'17P','29,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(39,'17P','24,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(40,'17P','11,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(41,'1A','613',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(42,'1P','72',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(43,'2A','731',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(44,'2A','731,39',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(45,'2P','732',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(46,'2P','732,736',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(47,'2P','732,39',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(48,'2P','731,736',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(49,'3P','955',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(50,'4A','11,39',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(51,'4P','30,736',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(52,'4P','11,736',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(53,'4P','30,39',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(54,'5A','735',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(55,'6A','22,734',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(56,'7A','932,734',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(57,'8A','932,39',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(58,'9A','73,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(59,'9P','74,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(60,'9P','73,733',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(61,'9P','733,979',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(62,'9P','74,969',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(63,'9P','969,979',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(64,'9P','74,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(65,'9P','73,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(66,'9P','979,1044',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(67,'9P','733,1045',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(68,'9P','969,1045',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(69,'9P','1044,1045',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51'),(70,'Other','1046',0,NULL,NULL,NULL,'2020-09-11 15:20:51','2020-09-11 15:20:51');
/*!40000 ALTER TABLE `medication_regimen` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-09-11 15:25:51
