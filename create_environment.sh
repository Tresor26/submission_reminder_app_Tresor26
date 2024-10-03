#!/bin/bash

# Create the main directory and subdirectories
mkdir -p submission_reminder_app/{app,modules,assets,config}

# Create the reminder script
cat <<EOT > submission_reminder_app/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env  
source ./modules/functions.sh  

# Path to the submissions file
submissions_file="./assets/submissions.txt" 

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOT
chmod +x submission_reminder_app/app/reminder.sh

# Create the functions script
cat <<EOT > submission_reminder_app/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then 
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOT
chmod +x submission_reminder_app/modules/functions.sh

# Create the config file
cat <<EOT > submission_reminder_app/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOT

# Copy the submissions file
cp submissions.txt submission_reminder_app/assets/submissions.txt

# Populate the submissions file
cat <<EOT >> submission_reminder_app/assets/submissions.txt
Tresor, Shell Navigation, submitted
Eddy, Shell Navigation, not submitted
Jean, Shell Navigation, not submitted
EOT

# Create the startup script
cat <<EOT > submission_reminder_app/startup.sh
#!/bin/bash

# Start reminder script if it exists
if [ -f "./app/reminder.sh" ]; then
    echo "Starting the reminder script..."
    bash ./app/reminder.sh
else
    echo "Reminder script not found. Exiting."
fi
EOT
chmod +x submission_reminder_app/startup.sh

echo "Environment setup complete"

