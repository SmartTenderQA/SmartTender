*** Settings ***
Resource    keywords.robot
Resource  	../../common/header_old/header_old.robot

*** Variables ***
${fast_login}			${True}


*** Keywords ***
Авторизуватися
	[Arguments]  ${login}  ${password}
	Run Keyword If
	...  ${fast_login} == ${True}
	...  POST authorization  ${login}  ${password}  ELSE
	...  Manual authorization  ${login}  ${password}
	Перевірити успішність авторизації


Завершити сеанс користувача
	Go To  ${start_page}
	Натиснути Вийти

