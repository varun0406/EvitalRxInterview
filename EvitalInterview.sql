-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: mysql-2759b698-kotwaniv04-f738.d.aivencloud.com    Database: Evital
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '54e6f380-ff2c-11ee-8c9b-c2682ea24a61:1-137';

--
-- Dumping data for table `TOTAL_DAILY_EARN`
--

LOCK TABLES `TOTAL_DAILY_EARN` WRITE;
/*!40000 ALTER TABLE `TOTAL_DAILY_EARN` DISABLE KEYS */;
INSERT INTO `TOTAL_DAILY_EARN` VALUES ('2024-04-21',3842.00),('2024-04-22',500.00),('2024-04-23',3304.00),('2024-04-24',1256.00),('2024-04-25',6656.00),('2024-04-26',8535.00),('2024-04-27',8448.00),('2024-04-28',4362.00),('2024-04-29',2250.00),('2024-04-30',1944.00),('2024-05-01',9985.00),('2024-05-02',3513.00),('2024-05-03',2894.00),('2024-05-04',2361.00),('2024-05-05',2361.00);
/*!40000 ALTER TABLE `TOTAL_DAILY_EARN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `TOTAL_WEEKLY_EARN`
--

LOCK TABLES `TOTAL_WEEKLY_EARN` WRITE;
/*!40000 ALTER TABLE `TOTAL_WEEKLY_EARN` DISABLE KEYS */;
INSERT INTO `TOTAL_WEEKLY_EARN` VALUES ('2024-04-21',32541.00),('2024-04-28',24948.00),('2024-05-05',2361.00);
/*!40000 ALTER TABLE `TOTAL_WEEKLY_EARN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `order_statuses`
--

LOCK TABLES `order_statuses` WRITE;
/*!40000 ALTER TABLE `order_statuses` DISABLE KEYS */;
INSERT INTO `order_statuses` VALUES (1,'Shipped');
/*!40000 ALTER TABLE `order_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,20,'2024-04-21',3842.00,'aa',1),(2,1,'2024-04-22',500.00,'sss',1),(3,11,'2024-04-23',3304.00,'cc',1),(4,2,'2024-04-24',1256.00,'aa',1),(5,20,'2024-04-25',6656.00,'sss',1),(6,17,'2024-04-26',8535.00,'cc',1),(7,4,'2024-04-27',8448.00,'aa',1),(8,19,'2024-04-28',4362.00,'sss',1),(9,8,'2024-04-29',2250.00,'cc',1),(10,15,'2024-04-30',1944.00,'aa',1),(11,15,'2024-05-01',9985.00,'sss',1),(12,4,'2024-05-02',3513.00,'cc',1),(13,15,'2024-05-03',2894.00,'aa',1),(14,15,'2024-05-05',2361.00,'sss',1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'Evital'
--

--
-- Dumping routines for database 'Evital'
--
/*!50003 DROP FUNCTION IF EXISTS `calculate_total_sales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "calculate_total_sales"(date_param DATE) RETURNS decimal(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    
    -- Check if data for the given date already exists in total_daily_earn
    SELECT amount INTO total
    FROM TOTAL_DAILY_EARN
    WHERE DATEE = date_param;
    
    -- If data already exists, return the existing total
    IF total IS NOT NULL THEN
        RETURN total;
    END IF;

    -- Calculate the total sales for the given date
    SELECT SUM(total_amount) INTO total
    FROM orders
    WHERE DATE(order_date) = date_param;

    -- If total is NULL, set it to 0
    IF total IS NULL THEN
        SET total = 0;
    END IF;
    
    -- Insert a record into total_daily_earn
    INSERT INTO TOTAL_DAILY_EARN (DATEE, amount)
    VALUES (date_param, total);
    
    -- Return the total sales
    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_total_sales_daily` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "calculate_total_sales_daily"(date_param DATE) RETURNS decimal(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    
    -- Check if data for the given date already exists in total_daily_earn
    SELECT amount INTO total
    FROM TOTAL_DAILY_EARN
    WHERE DATEE = date_param;
    
    -- If data already exists, return the existing total
    IF total IS NOT NULL THEN
        RETURN total;
    END IF;

    -- Calculate the total sales for the given date
    SELECT SUM(total_amount) INTO total
    FROM orders
    WHERE DATE(order_date) = date_param;

    -- If total is NULL, set it to 0
    IF total IS NULL THEN
        SET total = 0;
    END IF;
    
    -- Insert a record into total_daily_earn
    INSERT INTO TOTAL_DAILY_EARN (DATEE, amount)
    VALUES (date_param, total);
    
    -- Return the total sales
    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_total_sales_weekly` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "calculate_total_sales_weekly"(start_date_param DATE) RETURNS decimal(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE end_date DATE;

    -- Calculate the end date of the week
    SET end_date = DATE_ADD(start_date_param, INTERVAL 6 DAY);
    
    -- Check if data for the given week already exists in total_weekly_earn
    SELECT total_amount INTO total
    FROM TOTAL_WEEKLY_EARN
    WHERE week_start_date = start_date_param;

    -- If data already exists, return the existing total
    IF total IS NOT NULL THEN
        RETURN total;
    END IF;

    -- Calculate the total sales for the given week
    SELECT SUM(total_amount) INTO total
    FROM orders
    WHERE order_date >= start_date_param AND order_date <= end_date;

    -- If total is NULL, set it to 0
    IF total IS NULL THEN
        SET total = 0;
    END IF;
    
    -- Insert a record into total_weekly_earn
    INSERT INTO TOTAL_WEEKLY_EARN (week_start_date, total_amount)
    VALUES (start_date_param, total);
    
    -- Return the total sales
    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetScheduledReports` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "GetScheduledReports"(IN freq VARCHAR(10))
BEGIN
    IF freq = 'daily' THEN
        SELECT * FROM TOTAL_DAILY_EARN;
    ELSEIF freq = 'weekly' THEN
        SELECT * FROM TOTAL_WEEKLY_EARN;
    ELSE
        SELECT 'Invalid frequency' AS Error;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateTotalDailyEarn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "UpdateTotalDailyEarn"()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE orderDate DATE;
    DECLARE calcTotal DECIMAL(10, 2);

    -- Cursor to fetch unique order dates from the orders table
    DECLARE orderDates CURSOR FOR
        SELECT DISTINCT DATE(order_date) AS order_date FROM orders;

    -- Declare handler for cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open cursor
    OPEN orderDates;

    -- Loop through each unique order date
    orderDatesLoop: LOOP
        FETCH orderDates INTO orderDate;
        IF done THEN
            LEAVE orderDatesLoop;
        END IF;

        -- Calculate total sales for the current order date
        SELECT SUM(total_amount) INTO calcTotal
        FROM orders
        WHERE DATE(order_date) = orderDate;

        -- Debugging: Output order date and calculated total for debugging
        SELECT orderDate, calcTotal;

        -- Update existing record in total_daily_earn
        UPDATE TOTAL_DAILY_EARN
        SET amount = calcTotal
        WHERE datee = orderDate;

        -- Check if the update affected any rows
        IF ROW_COUNT() = 0 THEN
            -- No rows were updated, so insert a new record into total_daily_earn
            -- This should not happen if there is data integrity, but we handle it as a precaution
            INSERT INTO TOTAL_DAILY_EARN (datee, amount)
            VALUES (orderDate, calcTotal);
        END IF;

    END LOOP;

    -- Close cursor
    CLOSE orderDates;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-22  9:23:54
