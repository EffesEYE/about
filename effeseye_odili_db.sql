-- Chrome MySQL Admin version 4.10.0
--
-- Host: eu-cdbr-west-03.cleardb.net
-- ------------------------------------------------------
-- Server version 5.6.49-log

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
-- Current Database: `effeseye_odili_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `effeseye_odili_db` /*!40100 DEFAULT CHARACTER SET utf8 */;

use `effeseye_odili_db`;

--
-- Table structure for table `bankaccounts`
--

DROP TABLE IF EXISTS `bankaccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bankaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nuban` varchar(255) NOT NULL,
  `bank` varchar(255) NOT NULL,
  `owner` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nuban` (`nuban`),
  KEY `owner` (`owner`),
  CONSTRAINT `bankaccounts_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bankaccounts`
--

LOCK TABLES `bankaccounts` WRITE;
/*!40000 ALTER TABLE `bankaccounts` DISABLE KEYS */;
INSERT INTO `bankaccounts` VALUES (1,'9267409167','GTB',1,'2020-11-03 01:32:11','2020-11-03 01:32:11'),(11,'0002674983','UBA',1,'2020-11-03 01:32:11','2020-11-03 01:32:11'),(21,'8271670083','Zenith',1,'2020-11-03 01:32:11','2020-11-03 01:32:11');
/*!40000 ALTER TABLE `bankaccounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL,
  `currency` enum('NGN','USD') NOT NULL,
  `tnxtype` enum('AIRTIME','ELECTRICITY','PAYTV') NOT NULL,
  `status` enum('PENDING','FAILED','SUCCEEDED') NOT NULL,
  `tnxdetails` text,
  `user` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1000,'NGN','AIRTIME','SUCCEEDED',NULL,1,'2020-11-03 01:32:11','2020-11-03 01:32:11'),(11,5000,'NGN','PAYTV','SUCCEEDED',NULL,1,'2020-11-03 01:32:11','2020-11-03 01:32:11'),(21,12000,'NGN','ELECTRICITY','SUCCEEDED',NULL,1,'2020-11-03 01:32:11','2020-11-03 01:32:11');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sequelizemeta`
--

DROP TABLE IF EXISTS `sequelizemeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sequelizemeta` (
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequelizemeta`
--

LOCK TABLES `sequelizemeta` WRITE;
/*!40000 ALTER TABLE `sequelizemeta` DISABLE KEYS */;
INSERT INTO `sequelizemeta` VALUES ('20201021032034-create-user.js'),('20201021035319-create-payment.js'),('20201021100819-create-bank-account.js');
/*!40000 ALTER TABLE `sequelizemeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bvn` varchar(11) DEFAULT NULL,
  `hashedpassword` varchar(64) NOT NULL,
  `accountid` varchar(255) DEFAULT NULL,
  `accounttype` enum('USER','ADMIN') NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `firstname` varchar(30) NOT NULL,
  `middlename` varchar(30) DEFAULT NULL,
  `lastname` varchar(30) NOT NULL,
  `phone` varchar(14) NOT NULL,
  `lastseen` datetime DEFAULT NULL,
  `lasttnx` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accountid` (`accountid`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'12345678901','$2b$10$/I6XWT4EaO24ck4Q/.XJUe1iPHSg9e49me5yXFyspIOxbNuYDZhse','rythgldjfrig094745970497594','USER','lol@example.com','James','Baker','Bond','08167352983',NULL,NULL,'2020-11-03 01:32:11','2020-11-03 01:32:11'),(11,'23456789012','30482304-2355694759894532f-sdbfsdhkdshfk564','dhfdshtorytooutoueretertper','USER','moi@example.com','Moi','Judith','Eze','08046828639',NULL,NULL,'2020-11-03 01:32:11','2020-11-03 01:32:11'),(21,'34567890123','p3984538657493980ndfjhdskfhg487534498759345645','gjlidsfhgi567045584843076674','USER','joi@example.com','Joi','Mordy','Ekene','09175849274',NULL,NULL,'2020-11-03 01:32:11','2020-11-03 01:32:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-03 05:21:42