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


Поправити лінку для IP
	[Arguments]  ${href}
	${href}  Run Keyword If  '${IP}' != '${EMPTY}'  convert_url  ${href}  ${IP}
	...  ELSE  Set Variable  ${href}
	[Return]  ${href}


Отримати та залогувати data_session
	${s2b}  get_library_instance  Selenium2Library
	${webdriver}  Call Method  ${s2b}  _current_browser
	Create Session  api  http://autotest.it.ua:4444/grid/api/testsession?session=${webdriver.__dict__['capabilities']['webdriver.remote.sessionid']}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	Log  ${webdriver}
	Log  ${webdriver.__dict__}
	Log  ${webdriver.__dict__['capabilities']}
	Log  ${data}