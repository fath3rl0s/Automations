# Automations
Carlos Enamorado
2024

MORE BASH!!!!

Script Explanation:
Variables:

TARGETS: The network range to scan.
SCAN_REPORT and OPENVAS_REPORT: File paths for saving the scan reports, with timestamps for uniqueness.
Functions:

run_nmap_scan(): Executes an Nmap scan and saves the results to a text file.
run_openvas_scan(): Executes an OpenVAS scan, waits for its completion, and saves the report as an XML file.
send_email_notification(): Sends an email with the scan reports attached.
Main Execution:

Runs the Nmap and OpenVAS scans.
Sends an email notification with the scan reports.
Prerequisites:
Nmap and OpenVAS should be installed and configured on the system.
Mail command should be set up for email notifications.

Adjust as needed
