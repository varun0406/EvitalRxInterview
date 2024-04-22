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
----------------------------
CREATE TABLE "orders" (
  "order_id" int NOT NULL AUTO_INCREMENT,
  "customer_id" int DEFAULT NULL,
  "order_date" date DEFAULT NULL,
  "total_amount" decimal(10,2) DEFAULT NULL,
  "shipping_address" text,
  "status_id" int DEFAULT NULL,
  PRIMARY KEY ("order_id"),
  KEY "status_id" ("status_id"),
  CONSTRAINT "orders_ibfk_1" FOREIGN KEY ("status_id") REFERENCES "order_statuses" ("status_id")
);
-
CREATE TABLE "order_statuses" (
  "status_id" int NOT NULL AUTO_INCREMENT,
  "status_name" varchar(50) DEFAULT NULL,
  PRIMARY KEY ("status_id")
);
-
First the Index.js file should be run for initialising the server then you must have postman or any another api caller 

For Scheduler

There is Scheduler.js file which should be startd after  iniitalising server in another terminal 
