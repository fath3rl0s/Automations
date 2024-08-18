# Automations
# Carlos Enamorado

MORE BASH (and some python)!!!!


TARGETS: The network range to scan.
SCAN_REPORT and OPENVAS_REPORT: File paths for saving the scan reports, with timestamps for uniqueness.
Functions:

- run_nmap_scan(): Run Nmap scan and saves the results to a text file.
- WIP: run_openvas_scan(): Executes an OpenVAS scan, waits for its completion, and saves the report as an XML file.
- send_email_notification(): Calls python script that authenticates with Google - AUTH 2.0 (Requires token and Gmail permissions defined in Scope)
- Creates Nessus Report from a previously deifined scan (Nessus Essentials API does not allow for orchestration of scans - upgrade to configure)


Current Execution:

Runs and creates Nmap scan results.
Calls Nessus API to build a report against machine
Sends an email notification with the scan reports.

Prerequisites:
NMAP
OPENVAS
NESSUS
GOOGLE CLOUD PROJECT - Google GMAIL allowed in Project Scope, OAUTH 2.0 Credentials
BASH
PYTHON3
