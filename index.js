const mysql = require('mysql');
const express = require("express");
const PORT = 3000;
const app = express();
const reportrunner = require('./reportrunner');

// Create a connection pool to the database
const pool = mysql.createPool({
    connectionLimit: 10,
    host: "mysql-2759b698-kotwaniv04-f738.d.aivencloud.com",
    port: 25192,
    user: "avnadmin",
    password: "AVNS_vXk0o9vU80f3EwAA3Te",
    database: "Evital"
});
app.post("/run-reports", (req, res) => {
    reportrunner.runReport();
    res.status(200).send("Reports generated successfully");
});
// Create a new scheduled report
// Create a new scheduled report
app.post("/scheduled-reports", (req, res) => {
    // Extract the date from the request body
    const date = req.query.date;

    // Get a connection from the pool
    pool.getConnection((err, connection) => {
        if (err) {
            console.error("Error getting connection from pool:", err);
            res.status(500).send("Error creating scheduled report");
            return;
        }

        // Execute the query
        connection.query(
            "SELECT calculate_total_sales(?) AS total_sales;",
            [date],
            (err, result) => {
                // Release the connection back to the pool
                connection.release();

                if (err) {
                    console.error("Error creating scheduled report:", err);
                    res.status(500).send("Error creating scheduled report");
                    return;
                }
                
                // Extract the total sales value from the result
                const totalSales = result[0].total_sales;
                
                console.log("Total sales:", totalSales);
                res.status(201).json({ totalSales });
            }
        );
    });

});
app.put("/scheduled-reports/", (req, res) => {
    const freq = req.query.freq;
    const date = req.query.date;
    const amount = req.query.amount;
    pool.getConnection((err, connection) => {
        if (err) {
            console.error("Error getting connection from pool:", err);
            res.status(500).send("Error updating scheduled report");
            return;
        }
        if (freq === 'daily') {
            connection.query(
                "update TOTAL_DAILY_EARN SET amount = ? WHERE DATEE = ?",
                [ amount,date],
                (err, results) => {
                    connection.release();
                    if (err) {
                        console.error("Error updating scheduled report:", err);
                        res.status(500).send("Error updating scheduled report");
                        return;
                    }
                    res.status(204).json({ message: 'Scheduled report updated successfully' });

                }
            );
        } else if (freq === 'weekly') {
            connection.query(
                "update TOTAL_WEEKLY_EARN SET total_amount = ? WHERE week_start_date = ?",
                [amount,date],
                (err, results) => {
                    connection.release();
                    if (err) {
                        console.error("Error updating scheduled report:", err);
                        res.status(500).send("Error updating scheduled report");
                        return;
                    }
                    res.status(204).json({ message: 'Scheduled report updated successfully' });

                }
            );
        } else {
            res.status(400).send("Invalid frequency");
            connection.release();
        }
    });
});

app.get("/scheduled-reports", (req, res) => {
    const freq = req.query.freq; // Get the frequency parameter from the query string

    // Get a connection from the pool
    pool.getConnection((err, connection) => {
        if (err) {
            console.error("Error getting connection from pool:", err);
            res.status(500).send("Error retrieving scheduled reports");
            return;
        }

        // Call the stored procedure
        connection.query(
            "CALL GetScheduledReports(?)",
            [freq],
            (err, results) => {
                // Release the connection back to the pool
                connection.release();

                if (err) {
                    console.error("Error retrieving scheduled reports:", err);
                    res.status(500).send("Error retrieving scheduled reports");
                    return;
                }

                // Send the result to the client
                res.json(results[0]);
            }
        );
    });
});
app.post("/run-reports",(req,res)=>{
    
})
// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
