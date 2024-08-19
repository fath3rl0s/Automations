# Automations


<img width="918" alt="image" src="https://github.com/user-attachments/assets/b69d5b67-c504-4e04-92d9-0693b015f15d">


MORE BASH (and some python)!!!!

Application that automates vulnerabilityy scans from NMAP, OpenVas and calls Nessus API to create a pdf report of targets.
Emails each report to GMAIL using OAUTH 2.0 straight from Linux



🚧 Current Execution:
- Runs and creates Nmap scan results.
- Calls Nessus API to build a report against machine
- Sends an email notification with the scan reports.

🛠️ Prerequisites:
- NMAP
- OPENVAS
- NESSUS
- GOOGLE CLOUD PROJECT - GMAIL APP allowed in Project Scope, OAUTH 2.0 Credentials
- BASH
- PYTHON3
- pip3 install --upgrade google-auth-oauthlib google-auth-httplib2
- pip3 install google-api-python-client

🪜 Steps
1. Download oauth.py, vulnEmail.py, and Vuln_Reporter.sh
2. Run oauth.py to generate a valid Google Token (Your browser should launch and prompt for authentication) to be used by vulnEmail.py
3. Run Vuln_Reporter.sh (requires vulnEmail.py to send email)
