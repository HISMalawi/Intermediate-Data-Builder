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

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arv_drugs`
--

LOCK TABLES `arv_drugs` WRITE;
/*!40000 ALTER TABLE `arv_drugs` DISABLE KEYS */;

INSERT INTO arv_drugs(drug_id)
VALUES(5),(6),(31),(32),(95),(41),(42),(177),(957),(39),(89),(736),(984),(21),(22),(817),(968),(971),(11),(28),(29),
       (30),(951),(2),(3),(72),(104),(613),(730),(813),(23),(73),(74),(94),(739),(9),(10),(36),(37),(38),(14),(40),
       (614),(731),(732),(955),(70),(71),(90),(91),(737),(738),(735),(815),(816),(733),(969),(734),(814),(932),(933),
       (934),(952),(954),(976),(977),(978),(979),(983),(980),(981),(982);

/*!40000 ALTER TABLE `arv_drugs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `medication_regimen`
--

LOCK TABLES `medication_regimen` WRITE;
/*!40000 ALTER TABLE `medication_regimen` DISABLE KEYS */;

INSERT INTO medication_regimen
(regimen, drug_composition, voided, voided_by, voided_date, void_reason, created_at, updated_at)
VALUES('0A', '733,968', 0, NULL, NULL, NULL, now(), now()),
('0P', '22,733', 0, NULL, NULL, NULL, now(), now()),
('0P', '969,968', 0, NULL, NULL, NULL, now(), now()),
('0A', '22,969', 0, NULL, NULL, NULL, now(), now()),
('2P', '732', 0, NULL, NULL, NULL, now(), now()),
('2P', '732,736', 0, NULL, NULL, NULL, now(), now()),
('2P', '39,732', 0, NULL, NULL, NULL, now(), now()),
('2A', '731', 0, NULL, NULL, NULL, now(), now()),
('2A', '39,731', 0, NULL, NULL, NULL, now(), now()),
('4P', '30,736', 0, NULL, NULL, NULL, now(), now()),
('4P', '11,736', 0, NULL, NULL, NULL, now(), now()),
('4P', '30,39', 0, NULL, NULL, NULL, now(), now()),
('4A', '11,39', 0, NULL, NULL, NULL, now(), now()),
('5A', '735', 0, NULL, NULL, NULL, now(), now()),
('6A', '22,734', 0, NULL, NULL, NULL, now(), now()),
('7A', '734,932', 0, NULL, NULL, NULL, now(), now()),
('8A', '39,932', 0, NULL, NULL, NULL, now(), now()),
('9P', '74,733', 0, NULL, NULL, NULL, now(), now()),
('9P', '73,733', 0, NULL, NULL, NULL, now(), now()),
('9P', '733,979', 0, NULL, NULL, NULL, now(), now()),
('9P', '74,969', 0, NULL, NULL, NULL, now(), now()),
('9A', '73,969', 0, NULL, NULL, NULL, now(), now()),
('10A', '73,734', 0, NULL, NULL, NULL, now(), now()),
('11P','74,736', 0, NULL, NULL, NULL, now(), now()),
('11P', '73,736', 0, NULL, NULL, NULL, now(), now()),
('11P', '39,74', 0, NULL, NULL, NULL, now(), now()),
('11A', '39,73', 0, NULL, NULL, NULL, now(), now()),
('12A', '976,977,982', 0, NULL, NULL, NULL, now(), now()),
('13A', '983', 0, NULL, NULL, NULL, now(), now()),
('14A', '982,984', 0, NULL, NULL, NULL, now(), now()),
('15A', '969,982', 0, NULL, NULL, NULL, now(), now());

/*!40000 ALTER TABLE `medication_regimen` ENABLE KEYS */;
UNLOCK TABLES;