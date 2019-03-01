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
	${message}  Wait Until Keyword Succeeds  ${timeout}  15 s  Перевірити наявність листа за темою  ${gmail}  ${subject}
	[Return]  ${message}


Перевірити наявність листа за темою
	[Arguments]  ${gmail}  ${subject}
	${message}  Call Method  ${gmail}  get_last_mail_with_subject  ${subject}
	${time is}  get_message_date  ${message}
	${time status}  compare_dates_smarttender  ${TEST START TIME}  <=  ${time is}
	Should Be Equal  ${time status}  ${True}
	[Return]  ${message}