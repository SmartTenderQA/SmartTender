*** Settings ***
Variables   /home/testadm/users_variables.py
Variables   ../users_variables.py


*** Variables ***
${IP}


*** Keywords ***
Змінити стартову сторінку для IP
	${start_page}  Run Keyword If  '${IP}' != ''  Set Variable  ${IP}
	...  ELSE  Set Variable  ${start_page}
	Set Global Variable  ${start_page}


Отримати стартову сторінку
	[Arguments]  ${site}
	${start_page}  Run Keyword If  "${site}" == "prod"  Set Variable  ${prod}
	...  ELSE  Set Variable  ${test}
	Set Global Variable  ${start_page}
	[Return]  ${start_page}


Отримати дані користувача
	[Arguments]  ${user}
	${a}  Create Dictionary  a  ${users_variables}
	${users_variables}  Set Variable  ${a.a}
	Set Global Variable  ${name}  ${users_variables.${user}.name}
	Set Global Variable  ${role}  ${users_variables.${user}.role}
	Set Global Variable  ${site}  ${users_variables.${user}.site}
	[Return]  ${users_variables.${user}.login}  ${users_variables.${user}.password}


Поправити лінку для IP
	[Arguments]  ${href}
	${href}  Run Keyword If  '${IP}' != '${EMPTY}'  convert_url  ${href}  ${IP}
	...  ELSE  Set Variable  ${href}
	[Return]  ${href}