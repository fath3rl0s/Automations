#!/bin/bash
#
# CARLOS ENAMORADO
#
# WIP

# Google announced on May 15, 2024 that they would be turning off access to less secure apps starting on June 15, 2024, 
# and fully retiring the option on September 30, 2024. 
# To continue using these types of apps with your Google accounts, you must switch to a more secure type of access called OAuth 2.0

# DOWNLOAD PYTHON OAUTH
# apt-get install python3-pip
# pip3 install --upgrade google-auth-oauthlib google-auth-httplib2
# pip3 install google-api-python-client

# CREATE GOOGLE OAUTH ACCOUNT and Credentials
# https://support.google.com/cloud/answer/6158849?hl=en

# DOCUMENTATION
# https://mailtrap.io/blog/send-emails-with-gmail-api/



# Load Secret Variables
# .env:
# NESSUS API AUTH
#
# export USERNAME=""
# export PASSWORD=""
# export OAUTH=""

source /root/.env

# ANSI
CC="\033[0m"

RD="\033[31m"
GR="\033[32m"
YL="\033[33m"
BL="\033[34m"
MG="\033[35m"
CY="\033[36m"



cat << 'EOF'

 ===============================================================
 _     _        __                                               
(_)   (_)      (__)  _                                           
(_)   (_) _   _ (_) (_)__                                        
(_)   (_)(_) (_)(_) (____)                                       
 (_)_(_) (_)_(_)(_) (_) (_)                                      
  (___)   (___)(___)(_) (_)                                      
 _____   ______  _____    _____   _____  _______  ______  _____  
(_____) (______)(_____)  (_____) (_____)(__ _ __)(______)(_____) 
(_)__(_)(_)__   (_)__(_)(_)   (_)(_)__(_)  (_)   (_)__   (_)__(_)
(_____) (____)  (_____) (_)   (_)(_____)   (_)   (____)  (_____) 
( ) ( ) (_)____ (_)     (_)___(_)( ) ( )   (_)   (_)____ ( ) ( ) 
(_)  (_)(______)(_)      (_____) (_)  (_)  (_)   (______)(_)  (_)
                                                                 
 ===============================================================
carlos enamorado 
https://www.linkedin.com/in/carlos-analyst/
EOF
echo




# Set variables for scan
TARGETS=$(ip a | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,3}\b" | head -2 | tail -1)  # Network range to scan
SCAN_REPORT="/tmp/nmap_$(date +'%m-%d-%Y-%H:%M:%S').txt"

# Function to run Nmap scan
run_nmap_scan() {
  
  echo
  printf $RD"NMAP"$CC
  echo
  echo -e "$YL[-] Running Nmap Scan on network: $TARGETS using:$CC"
  echo -e "$YL[-] nmap -sCV --script vulners -T4 -v$CC"
  
  nmap -sCV --script vulners -T4 -v $TARGETS > $SCAN_REPORT 2>&1 &
  nmap_pid=$!

  while kill -0 "$nmap_pid" >/dev/null 2>&1;do
          printf $RD'[*]'$CC
          sleep 1
  done
  echo
  echo -e "$GR[+] Nmap scan completed. Report saved to $MG$SCAN_REPORT$CC"
}


# Nessus API details
NESSUS_HOST="https://localhost:8834"
SCAN_ID="9"  # Replace with your scan ID

# Function to authenticate and get a session token
get_token() {
  local response
  response=$(curl -s -k -X POST -H "Content-Type: application/json" \
    -d "{\"username\":\"$USERNAME\", \"password\":\"$PASSWORD\"}" \
    "$NESSUS_HOST/session")
  echo "$response" | jq -r '.token'
}

# Function to export and download the Nessus report
download_report() {
  local token="$1"
  local scan_id="$2"
  local format="pdf"  # Change format if needed
  local export_id
  local file_id
  local status
  local download_url

  # Initiate the export
  export_id=$(curl -s -k -X POST -H "X-Cookie: token=$token" -H "Content-Type: application/json" \
    -d "{\"format\":\"$format\", \"chapters\":\"vuln_hosts_summary\"}" \
    "$NESSUS_HOST/scans/$scan_id/export" | jq -r '.file')

  # Poll until the export is ready
  while true; do
    status=$(curl -s -k -H "X-Cookie: token=$token" "$NESSUS_HOST/scans/$scan_id/export/$export_id/status" | jq -r '.status')
    if [ "$status" == "ready" ]; then
      break
    fi
    echo
    printf $RD"TENABLE NESSUS"$CC
    echo
    echo -e "$YL[-] Pulling the Nessus Report as a PDF$CC"
    sleep 10
  done

  # Download the report
  download_url="$NESSUS_HOST/scans/$scan_id/export/$export_id/download"
  curl -s -k -H "X-Cookie: token=$token" -o /tmp/nessus_report.pdf "$download_url"
  echo -e "$GR[+] Nessus Report saved to $MG/tmp/nessus_report.pdf$CC"
  echo
}

# Main logic
token=$(get_token)
if [ "$token" == "null" ] || [ -z "$token" ]; then
  echo -e "$RD[x] Authentication failed: Check your username and password.$CC"
  exit 1
else
  download_report "$token" "$SCAN_ID"
fi



# Function to send email notification
send_email_notification() {
  echo
  echo -e "$YL[+] Sending email notification...$CC"
  python3 /path/to/vulnEmail.py # ADJUST THIS
}


# Run the scans
run_nmap_scan
# run_openvas_scan

# Send email notification
send_email_notification
echo
echo 
echo -e "$GR[+] $MG Automated vulnerability scanning and reporting completed $GR[+]$CC"
echo


# Clean up Files
echo -e "$YL Delete report files? (y/n)$CC"
read -r delete

if [[ "${delete,,}" == "y" ]]; then
        echo
        rm /tmp/nmap* && rm /tmp/nessus*
        echo -e "$RD[x] Reports permanently deleted$CC"

else
        echo
        echo -e "$MG[+] Files were not deleted ***$CC"
        exit 0
fi
