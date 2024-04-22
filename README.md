# EvitalRxInterview

1) POST /run-reports: Triggers the generation of reports. No request body required.
2) POST /scheduled-reports: Creates a new scheduled report. Requires a date parameter in the request body.
3) PUT /scheduled-reports: Updates an existing scheduled report. Requires freq, date, and amount parameters in the request body.
4) GET /scheduled-reports: Retrieves scheduled reports based on frequency (freq) parameter provided in the query string.
5) DELETE /scheduled-reports : Deletes the Report you want based on frequency(fred) and date parameter.
host: "mysql-2759b698-kotwaniv04-f738.d.aivencloud.com",
port: 25192,
user: "avnadmin",
password: "AVNS_vXk0o9vU80f3EwAA3Te",
database: "Evital"
Run Report Endpoint:- Activates the Function in Nodejs, Which will restruture/recompile all the reports and Update the existing if there is any update in data in Orders table and also Update the Reports if neccessary.
Scheduler JS:- It is designed In a way that it will be give post request to Run-reports api and first directly on running and then 24 hrs later.

partial Programming logic is wriiten nodejs and partial in mysql funtions and triggers 
---------
CREATE DEFINER="avnadmin"@"%" PROCEDURE "GetScheduledReports"(IN freq VARCHAR(10))
BEGIN
    IF freq = 'daily' THEN
        SELECT * FROM TOTAL_DAILY_EARN;
    ELSEIF freq = 'weekly' THEN
        SELECT * FROM TOTAL_WEEKLY_EARN;
    ELSE
        SELECT 'Invalid frequency' AS Error;
    END IF;
END
-------------
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

END
--
----------------------------

-
First the Index.js file should be run for initialising the server then you must have postman or any another api caller 

For Scheduler

There is Scheduler.js file which should be startd after  iniitalising server in another terminal 
