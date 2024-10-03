#!/bin/bash

# Start reminder script if it exists
if [ -f "./app/reminder.sh" ]; then
    echo "Starting the reminder script..."
    bash ./app/reminder.sh
else
    echo "Reminder script not found. Exiting."
fi
