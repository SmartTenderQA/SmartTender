*** Settings ***


*** Keywords ***
Розпочати роботу з Gmail
	[Arguments]  ${user}
	${login}  Отримати дані користувача по полю  ${user}  login
	${mail_password}  Отримати дані користувача по полю  ${user}  mail_password
	${gmail}  create_email_object  ${login}  ${mail_password}
	[Return]  ${gmail}


Дочекатися отримання листа на пошту
	[Arguments]  ${gmail}  ${timeout}  ${subject}
	${time now -5 min}  Отримати час на машині  time  -5
	${message}  Wait Until Keyword Succeeds  ${timeout}  15 s  Перевірити наявність листа за темою  ${gmail}  ${subject}  ${time now -5 min}
	[Return]  ${message}


Перевірити наявність листа за темою
	[Arguments]  ${gmail}  ${subject}  ${time now -5 min}
	${message}  Call Method  ${gmail}  get_last_mail_with_subject  ${subject}
	${date is}  get_message_date  ${message}
	${is today}  Evaluate  '${date is}'[:'${date is}'.index('.')] == str(datetime.date.today().day)  datetime
	Run Keyword If  ${is today} == ${False}  Fail
	${time is}  get_message_time  ${message}
	${time status}  compare_dates_smarttender  ${time now -5 min}  <=  ${time is}
	Should Be Equal  ${time status}  ${True}
	[Return]  ${message}