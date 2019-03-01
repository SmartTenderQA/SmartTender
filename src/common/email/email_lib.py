import imaplib
import email
from datetime import datetime
from email.header import decode_header, make_header
import re
import os
import slate3k as slate
import logging



def create_email_object(login, password, smtp_server="imap.gmail.com"):
	return Email(login, password, smtp_server)


class Email:

	_smtp_port = 993

	def __init__(self, login, password, smtp_server="imap.gmail.com"):
		self.login = login
		self.password = password
		self._smtp_server = smtp_server
		self.authentication()
		self.refresh_mail_list()


	def authentication(self):
		self.mail = imaplib.IMAP4_SSL(self._smtp_server)
		try:
			self.mail.login(self.login, self.password)
		except:
			print("Ошибка при аутентификацие.")


	def refresh_mail_list(self):
		self.mail.select('inbox')
		status, content = self.mail.search(None, 'ALL')
		if status == 'OK':
			self.messages_IDs = content[0].split()
			self.messages_IDs.reverse()
			self.messages_Count = len(self.messages_IDs)


	def get_mail_by_id(self, id):
		status, content = self.mail.fetch(id, '(RFC822)')
		if status == 'OK':
			return email.message_from_bytes(content[0][1])


	def get_last_mail_with_subject(self, subject):
		if self is not None:
			self.refresh_mail_list()
			for i in self.messages_IDs:
				msg = self.get_mail_by_id(i)
				if subject in get_message_subject(msg):
					print('message date: ' + get_message_date(msg))
					print('message subject: ' + get_message_subject(msg))
					print('message from: ' + __decode_content__(msg['from']))
					print('message to: ' + msg['to'])
					return msg
			return "Oops! Листа з темою '" + subject + "' не знайдено"
		else:
			return "Oops! Помилка з об'єктом 'gmail'"



def __decode_content__(content):
	return str(make_header(decode_header(content)))


def get_message_subject(msg):
	msg_subject = __decode_content__(msg['subject'])
	return msg_subject


def get_message_date(msg):
	date_tuple = email.utils.parsedate_tz(msg['date'])
	date = datetime.fromtimestamp(email.utils.mktime_tz(date_tuple))
	return ('{:%d.%m.%Y %H:%M:%S}'.format(date))


def get_message_time(msg):
	date_tuple = email.utils.parsedate_tz(msg['date'])
	date = datetime.fromtimestamp(email.utils.mktime_tz(date_tuple))
	return ('{:%H:%M}'.format(date))


def get_message_content(msg):
	body = ""
	if msg.is_multipart():
		for part in msg.walk():
			ctype = part.get_content_type()
			cdispo = str(part.get('Content-Disposition'))
			# skip any text/plain (txt) attachments
			if ctype == 'text/plain' and 'attachment' not in cdispo:
				body = part.get_payload(decode=True)  # decode
				break
	else:
		body = msg.get_payload(decode=True)
	return body.decode("utf-8")


def get_href_from_message(content):
	return re.findall('[^\"]+ResetPassword[^\"]+', content)[0]


def get_attachment_from_message(msg, att_type):
	attachments = msg.get_payload()
	for i in attachments:
		if att_type in i.get_content_type():
			file_name = __decode_content__(i.get_filename())
			path = os.getcwd() + '/test_output/' + file_name
			open(path, 'wb').write(i.get_payload(decode=True))
			logging.getLogger('pdfminer').setLevel(logging.ERROR)
			with open(path, 'rb') as f:
				file_content = slate.PDF(f)
			return { 'name': file_name, 'content': file_content[0]}
