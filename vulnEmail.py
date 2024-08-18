# Carlos Enamorado
# WIP
# Python script to add functionality to AutoScan.sh
# Creates a MIME message, encode it in base64, and send it using the Gmail API





import os
import base64
import glob
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

def create_message_with_attachments(sender, to, subject, body_text, attachments):
    message = MIMEMultipart()
    message['to'] = to
    message['from'] = sender
    message['subject'] = subject

    # Attach the body text
    message.attach(MIMEText(body_text))

    # Attach files
    for file_path in attachments:
        part = MIMEBase('application', 'octet-stream')
        with open(file_path, 'rb') as file:
            part.set_payload(file.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', f'attachment; filename={os.path.basename(file_path)}')
        message.attach(part)

    # Encode the message
    raw_message = base64.urlsafe_b64encode(message.as_bytes()).decode('utf-8')
    return {'raw': raw_message}

def send_message(service, user_id, message):
    try:
        sent_message = service.users().messages().send(userId=user_id, body=message).execute()
        print(f'Message Id: {sent_message["id"]}')
    except Exception as e:
        print(f'An error occurred: {e}')

def main():
    # Load credentials from token.json
    creds = Credentials.from_authorized_user_file('/path/to/token.json', ['https://www.googleapis.com/auth/gmail.send']) # EDIT TOKEN PATH 
    service = build('gmail', 'v1', credentials=creds)

    # Email details
    sender = 'your_email@gmail.com' # EDIT THIS
    recipient = 'your_emailil@example.com' # EDIT THIS
    subject = 'Automated Vulnerability Scan Report'
    body_text = 'The automated vulnerability scan has been completed. Please find the attached reports.'

    # Use glob to find files matching the pattern
    nmap_files = glob.glob('/tmp/nmap*.txt') #ADJUST AS NEEDED
    openvas_report = '/tmp/openvas.txt'  # ADJUST AS NEEDED
    nessus_report = '/tmp/nessus_report.pdf' # ADJUST AS NEEDED

    # Combine all attachments
    attachments = nmap_files + [openvas_report]

    # Create and send the email
    message = create_message_with_attachments(sender, recipient, subject, body_text, attachments)
    send_message(service, 'me', message)

if __name__ == '__main__':
    main()
