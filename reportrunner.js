const mysql = require('mysql');


function runReport() {
    const pool = mysql.createPool({
        connectionLimit: 10,
        host: '',
        port: 25192,
        user: '',
        password: '',
        database: 'Evital'
    });

    // Function to update the total daily earnings
    function updateTotalDailyEarn() {
        // Fetch unique order dates from the orders table
        pool.query('SELECT DISTINCT DATE(order_date) AS order_date FROM orders', (error, results) => {
            if (error) {
                console.error('Error fetching order dates:', error);
                return;
            }

            // Loop through each unique order date
            results.forEach(row => {
                const orderDate = row.order_date;

                // Calculate total sales for the current order date
                pool.query('SELECT SUM(total_amount) AS total FROM orders WHERE DATE(order_date) = ?', [orderDate], (error, results) => {
                    if (error) {
                        console.error('Error calculating total sales:', error);
                        return;
                    }

                    const totalSales = results[0].total || 0; // If total is null, default to 0

                    // Check if a record already exists for the date in TOTAL_DAILY_EARN
                    pool.query('SELECT * FROM TOTAL_DAILY_EARN WHERE datee = ?', [orderDate], (error, results) => {
                        if (error) {
                            console.error('Error checking existing record:', error);
                            return;
                        }

                        if (results.length > 0) {
                            // Update existing record in TOTAL_DAILY_EARN
                            pool.query('UPDATE TOTAL_DAILY_EARN SET amount = ? WHERE datee = ?', [totalSales, orderDate], (error, results) => {
                                if (error) {
                                    console.error('Error updating record:', error);
                                    return;
                                }
                                console.log(`Record updated for date ${orderDate}`);
                            });
                        } else {
                            // Insert a new record into TOTAL_DAILY_EARN
                            pool.query('INSERT INTO TOTAL_DAILY_EARN (datee, amount) VALUES (?, ?)', [orderDate, totalSales], (error, results) => {
                                if (error) {
                                    console.error('Error inserting record:', error);
                                    return;
                                }
                                console.log(`Record inserted for date ${orderDate}`);
                            });
                        }
                    });
                });
            });
        });
    }

    // Function to update the total weekly earnings
    function updateTotalWeeklyEarn() {
        // Fetch unique week start dates from the orders table
        pool.query('SELECT MIN(order_date) AS week_start_date FROM orders GROUP BY YEAR(order_date), WEEK(order_date)', (error, results) => {
            if (error) {
                console.error('Error fetching week start dates:', error);
                return;
            }

            // Loop through each unique week start date
            results.forEach(row => {
                const weekStartDate = row.week_start_date;

                // Calculate total sales for the current week
                pool.query('SELECT SUM(total_amount) AS total FROM orders WHERE order_date >= ? AND order_date < DATE_ADD(?, INTERVAL 1 WEEK)', [weekStartDate, weekStartDate], (error, results) => {
                    if (error) {
                        console.error('Error calculating total sales:', error);
                        return;
                    }

                    const totalSales = results[0].total || 0; // If total is null, default to 0

                    // Check if a record already exists for the week in TOTAL_WEEKLY_EARN
                    pool.query('SELECT * FROM TOTAL_WEEKLY_EARN WHERE week_start_date = ?', [weekStartDate], (error, results) => {
                        if (error) {
                            console.error('Error checking existing record:', error);
                            return;
                        }

                        if (results.length > 0) {
                            // Update existing record in TOTAL_WEEKLY_EARN
                            pool.query('UPDATE TOTAL_WEEKLY_EARN SET total_amount = ? WHERE week_start_date = ?', [totalSales, weekStartDate], (error, results) => {
                                if (error) {
                                    console.error('Error updating record:', error);
                                    return;
                                }
                                console.log(`Record updated for week starting from ${weekStartDate}`);
                            });
                        } else {
                            // Insert a new record into TOTAL_WEEKLY_EARN
                            pool.query('INSERT INTO TOTAL_WEEKLY_EARN (week_start_date, total_amount) VALUES (?, ?)', [weekStartDate, totalSales], (error, results) => {
                                if (error) {
                                    console.error('Error inserting record:', error);
                                    return;
                                }
                                console.log(`Record inserted for week starting from ${weekStartDate}`);
                            });
                        }
                    });
                });
            });
        });
    }

    // Call the functions to update total daily and weekly earnings
    updateTotalDailyEarn();
    updateTotalWeeklyEarn();
}

// Call the runReport function

module.exports = {runReport};
