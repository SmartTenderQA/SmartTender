*** Variables ***
${users_variables_path1}   /home/testadm/users_variables.py
${users_variables_path2}   ${EXECDIR}/users_variables.py


*** Keywords ***
Змінити стартову сторінку для IP
	${n}  Evaluate  random.choice([8, 9])  random
	Run Keyword If
	...  '${IP}' == 'iis'  Run Keywords
	...  Set Global Variable  ${start_page}  http://iis${n}.smarttender.biz.int/   AND
	...  Set Global Variable  ${IP}  iis${n}  ELSE IF
	...  '${IP}' != ''
	...  Set Global Variable  ${start_page}  ${IP}


Поправити лінку для IP
	[Arguments]  ${href}
	${href}  Run Keyword If  '${IP}' != '${EMPTY}'  convert_url  ${href}  ${IP}
	...  ELSE  Set Variable  ${href}
	[Return]  ${href}


Отримати стартову сторінку
	[Arguments]  ${site}
	${start_page}  Run Keyword If  "${site}" == "prod"  Set Variable  ${prod}
	...  ELSE  Set Variable  ${test}
	Set Global Variable  ${start_page}
	[Return]  ${start_page}


Отримати дані користувача по полю
	[Arguments]  ${user}  ${key}
	${status}  Run Keyword And Return Status  Import Variables  ${users_variables_path1}
	Run Keyword If  ${status} == ${False}  Import Variables  ${users_variables_path2}
	${a}  Create Dictionary  a  ${users_variables}
	${users_variables}  Set Variable  ${a.a}
	[Return]  ${users_variables.${user}.${key}}

