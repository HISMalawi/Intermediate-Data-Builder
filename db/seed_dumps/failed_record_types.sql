-- MySQL dump 10.13  Distrib 5.7.27, for Linux (x86_64)
--
-- Host: localhost    Database: ids
-- ------------------------------------------------------
-- Server version	5.7.27-0ubuntu0.18.04.1

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
-- Table structure for table `failed_record_types`
--

DROP TABLE IF EXISTS `failed_record_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_record_types` (
  `failed_record_type_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`failed_record_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_record_types`
--

LOCK TABLES `failed_record_types` WRITE;
/*!40000 ALTER TABLE `failed_record_types` DISABLE KEYS */;
INSERT INTO `failed_record_types` VALUES (1,'person_name','2019-08-17 13:07:38','2019-08-17 13:07:38'),(2,'person_attribute','2019-08-17 13:07:38','2019-08-17 13:07:38'),(3,'person_address','2019-08-17 13:07:38','2019-08-17 13:07:38'),(4,'person_type','2019-08-17 13:07:38','2019-08-17 13:07:38'),(5,'encounter','2019-08-17 13:07:38','2019-08-17 13:07:38'),(6,'diagnosis','2019-08-17 13:07:38','2019-08-17 13:07:38'),(7,'pregnant_status','2019-08-17 13:07:38','2019-08-17 13:07:38'),(8,'breastfeeding_status','2019-08-17 13:07:38','2019-08-17 13:07:38'),(9,'vitals','2019-08-17 13:07:38','2019-08-17 13:07:38'),(10,'patient_history','2019-08-17 13:07:38','2019-08-17 13:07:38'),(11,'symptoms','2019-08-17 13:07:38','2019-08-17 13:07:38'),(12,'side_effects','2019-08-17 13:07:38','2019-08-17 13:07:38'),(13,'presenting_complaints','2019-08-17 13:07:38','2019-08-17 13:07:38'),(14,'tb_status','2019-08-17 13:07:39','2019-08-17 13:07:39'),(15,'outcomes','2019-08-17 13:07:39','2019-08-17 13:07:39'),(16,'family_planning','2019-08-17 13:07:39','2019-08-17 13:07:39'),(17,'appointment','2019-08-17 13:07:39','2019-08-17 13:07:39'),(18,'prescription','2019-08-17 13:07:39','2019-08-17 13:07:39'),(19,'lab_orders','2019-08-17 13:07:39','2019-08-17 13:07:39'),(20,'occupation','2019-08-17 13:07:39','2019-08-17 13:07:39'),(21,'dispensation','2019-08-17 13:07:39','2019-08-17 13:07:39'),(22,'relationships','2019-08-17 13:07:39','2019-08-17 13:07:39'),(23,'hiv_staging_info','2019-08-17 13:07:39','2019-08-17 13:07:39'),(24,'prescription_has_regimen','2019-08-17 13:07:39','2019-08-17 13:07:39'),(25,'lab_test_results','2019-08-17 13:07:39','2019-08-17 13:07:39'),(26,'user','2019-08-17 13:07:39','2019-08-17 13:07:39'),(27,'guardian','2019-08-17 13:07:39','2019-08-17 13:07:39'),(28,'provider','2019-08-17 13:07:39','2019-08-17 13:07:39'),(29,'patient','2019-08-17 13:07:39','2019-08-17 13:07:39'),
<<<<<<< HEAD
    (30,'client','2019-08-17 13:07:39','2019-08-17 13:07:39');
=======
    (30,'client','2019-08-17 13:07:39','2019-08-17 13:07:39'),(31,'adherence','2019-08-17 13:07:39','2019-08-17 13:07:39'),
    (32,'hts_result_given','2019-08-17 13:07:39','2019-08-17 13:07:39');
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
/*!40000 ALTER TABLE `failed_record_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-17 13:14:55
