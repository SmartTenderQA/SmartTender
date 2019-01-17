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
	Run Keyword If  "viewer" not in "${user}"  Run Keywords
	...  start_page.Відкрити вікно авторизації  AND
	...  login.Fill Login  ${login}  AND
	...  login.Fill Password  ${password}  AND
	...  login.Click Log In
	Run Keyword If  "tender_owner" == "${role}"
	...  Дочекатись закінчення загрузки сторінки(webclient)  ELSE
	...  Дочекатись закінчення загрузки сторінки
	Run Keyword If  "${role}" != "viewer" and "${role}" != "Bened"
	...  Wait Until Page Contains  ${name}  10
