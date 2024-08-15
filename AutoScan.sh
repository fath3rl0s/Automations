#!/bin/bash
#
# CARLOS ENAMORADO
# 2023-2024
# WIP

# Dependencies:
# sudo apt-get install mailutils
# sudo apt-get install msmtp


# Google announced on May 15, 2024 that they would be turning off access to less secure apps starting on June 15, 2024, 
# and fully retiring the option on September 30, 2024. 
# To continue using these types of apps with your Google accounts, 
# you must switch to a more secure type of access called OAuth 2.0



# Download Python OAuth 
# sudo apt-get install python3-pip
# pip3 install --upgrade google-auth-oauthlib google-auth-httplib2


# CREATE GOOGLE OAUTH ACCOUNT and Credentials
# https://support.google.com/cloud/answer/6158849?hl=en



# Set variables for scan
TARGETS="192.168.1.0/24"  # Network range to scan
SCAN_REPORT="/var/reports/scan_report_$(date +'%Y%m%d%H%M%S').txt"
OPENVAS_REPORT="/var/reports/openvas_report_$(date +'%Y%m%d%H%M%S').xml"

# Ensure the reports directory exists
mkdir -p /var/reports

# Function to run Nmap scan
run_nmap_scan() {
  echo "Running Nmap scan on $TARGETS..."
  nmap -sV -oN $SCAN_REPORT $TARGETS
  echo "Nmap scan completed. Report saved to $SCAN_REPORT"
}

# Function to run OpenVAS scan
run_openvas_scan() {
  echo "Running OpenVAS scan on $TARGETS..."
  
  # Replace with your OpenVAS scan command and options
  # Example using `omp` command (OpenVAS Management Protocol)
  omp -u admin -w admin_password -h localhost -p 9390 -S -X "<create_task><name>Automated Scan</name><comment>Automated scan of $TARGETS</comment><config id='daba56c8-73ec-11df-a475-002264764cea'/></create_task>" > task.xml
  TASK_ID=$(xmllint --xpath "string(//create_task_response/@id)" task.xml)
  
  omp -u admin -w admin_password -h localhost -p 9390 -X "<start_task task_id='$TASK_ID'/>"

  # Poll for task completion
  while true; do
    STATUS=$(omp -u admin -w admin_password -h localhost -p 9390 -G --details | grep $TASK_ID | awk '{print $6}')
    if [ "$STATUS" == "Done" ]; then
      break
    fi
    echo "Waiting for OpenVAS scan to complete..."
    sleep 60
  done

  # Get report
  omp -u admin -w admin_password -h localhost -p 9390 -R -f c402cc3e-b531-11e1-9163-406186ea4fc5 > $OPENVAS_REPORT
  echo "OpenVAS scan completed. Report saved to $OPENVAS_REPORT"
}

# Function to send email notification
send_email_notification() {
  TO="security_team@example.com"
  SUBJECT="Automated Vulnerability Scan Report"
  BODY="The automated vulnerability scan has been completed. Please find the attached reports."
  ATTACHMENTS="$SCAN_REPORT $OPENVAS_REPORT"

  echo "$BODY" | mail -s "$SUBJECT" -a $ATTACHMENTS $TO
  echo "Email notification sent to $TO"
}

# Run the scans
run_nmap_scan
run_openvas_scan

# Send email notification
send_email_notification

echo "Automated vulnerability scanning and reporting completed."
