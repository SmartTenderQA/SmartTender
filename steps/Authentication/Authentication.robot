*** Settings ***
Resource  ../../src/pages/start_page/login/login.robot


*** Keywords ***
Авторизуватися
	[Arguments]  ${user}=test_viewer
	${login}		Отримати дані користувача по полю  ${user}  login
	${password}		Отримати дані користувача по полю  ${user}  password
	${role}			Отримати дані користувача по полю  ${user}  role
	${name}			Отримати дані користувача по полю  ${user}  name
	Set Global Variable  ${role}
	Set Global Variable  ${name}
	Run Keyword If  'iis' in "${IP}" and "tender_owner" == "${role}"
	...  Авторизуватися(webclient)  ${user}  ${login}  ${password}  ELSE
	...  Авторизуватися(smart)  ${user}  ${login}  ${password}


Авторизуватися(smart)
	[Arguments]  ${user}  ${login}  ${password}
	Run Keyword If  "viewer" not in "${user}"  Run Keywords
	...  start_page.Відкрити вікно авторизації  AND
	...  login.Fill Login  ${login}  AND
	...  login.Fill Password  ${password}  AND
	...  login.Click Log In
	Run Keyword If  "tender_owner" == "${role}"
	...  Дочекатись закінчення загрузки сторінки(webclient)  ELSE
	...  Дочекатись закінчення загрузки сторінки
	Run Keyword If  "${role}" != "viewer" and "${role}" != "tender_owner"
	...  Wait Until Page Contains  ${name}  10


Авторизуватися(webclient)
	[Arguments]  ${user}  ${login}  ${password}
	Go To  ${start_page}/webclient/
	Wait Until Page Contains  Вхід в систему  60
	Заповнити текстове поле  xpath=//*[@data-name="Login"]//input  ${login}
	Input Text  xpath=//*[@data-name="Password"]//input  ${password}
	Click Element At Coordinates  xpath=(//*[contains(text(), 'Увійти')])[1]  -40  0
	Дочекатись закінчення загрузки сторінки(webclient)