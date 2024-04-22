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

First the Index.js file should be run for initialising the server then you must have postman or any another api caller 

For Scheduler

There is Scheduler.js file which should be startd after  iniitalising server in another terminal 
