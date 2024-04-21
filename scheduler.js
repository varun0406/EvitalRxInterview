const cron = require('node-cron');
const axios = require('axios');

// Define a cron schedule to run immediately
cron.schedule('* * * * *', () => {
    // Trigger the /run-reports endpoint
    axios.post('http://localhost:3000/run-reports')
        .then(response => {
            console.log('Reports generated successfully:', response.data);
        })
        .catch(error => {
            console.error('Error generating reports:', error);
        });

    // Stop the current cron job after execution
    this.destroy();
}, {
    scheduled: true,
    timezone: 'Asia/Kolkata' // Set timezone to India
});

// Define a cron schedule to run 24 hours later
cron.schedule('0 0 * * *', () => {
    // Trigger the /run-reports endpoint
    axios.post('http://localhost:3000/run-reports')
        .then(response => {
            console.log('Reports generated successfully:', response.data);
        })
        .catch(error => {
            console.error('Error generating reports:', error);
        });
}, {
    scheduled: true,
    timezone: 'Asia/Kolkata' // Set timezone to India
});

// Start the scheduler
console.log('Scheduler started. Reports will be generated now and 24 hours later.');
