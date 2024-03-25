-- MariaDB dump 10.19  Distrib 10.11.6-MariaDB, for Linux (x86_64)
--
-- Host: pvp-db.mysql.database.azure.com    Database: pvp_administratoriams
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `paskyra`
--

DROP TABLE IF EXISTS `paskyra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paskyra` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epastas` varchar(255) NOT NULL,
  `pilnas_vardas` varchar(255) NOT NULL,
  `slaptazodis` varchar(255) NOT NULL,
  `druska` varchar(255) NOT NULL,
  `registracijos_data` date NOT NULL,
  `paskutinio_prisijungimo_data` date NOT NULL,
  `busena` varchar(255) NOT NULL,
  `leidimai` smallint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paskyra`
--

LOCK TABLES `paskyra` WRITE;
/*!40000 ALTER TABLE `paskyra` DISABLE KEYS */;
/*!40000 ALTER TABLE `paskyra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesija`
--

DROP TABLE IF EXISTS `sesija`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sesija` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `galiojimo_pradzios_data` time NOT NULL,
  `galiojimo_pabaigos_data` time NOT NULL,
  `ip_adresas` varchar(255) NOT NULL,
  `aktyvus_pries_kiek_laiko` time NOT NULL,
  `busena` varchar(255) NOT NULL,
  `fk_paskyra_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_paskyra_id` (`fk_paskyra_id`),
  CONSTRAINT `sesija_ibfk_1` FOREIGN KEY (`fk_paskyra_id`) REFERENCES `paskyra` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesija`
--

LOCK TABLES `sesija` WRITE;
/*!40000 ALTER TABLE `sesija` DISABLE KEYS */;
/*!40000 ALTER TABLE `sesija` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-25 17:56:03
