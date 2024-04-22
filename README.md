# EvitalRxInterview
POST /run-reports: Triggers the generation of reports. No request body required.
POST /scheduled-reports: Creates a new scheduled report. Requires a date parameter in the request body.
PUT /scheduled-reports: Updates an existing scheduled report. Requires freq, date, and amount parameters in the request body.
GET /scheduled-reports: Retrieves scheduled reports based on frequency (freq) parameter provided in the query string.
DELETE /scheduled-reports : Deletes the Report you want based on frequency(fred) and date parameter.



 host: "mysql-2759b698-kotwaniv04-f738.d.aivencloud.com",
    port: 25192,
    user: "avnadmin",
    password: "AVNS_vXk0o9vU80f3EwAA3Te",
    database: "Evital"

First the Index.js file should be run for initialising the server then you must have postman or any another api caller 

For Scheduler

There is Scheduler.js file which should be startd after  iniitalising server in another terminal 
