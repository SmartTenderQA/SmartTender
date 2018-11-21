*** Settings ***
Resource  	../../src.robot
Resource    keywords.robot


*** Variables ***
${logout}                           id=LogoutBtn


*** Keywords ***
Авторизуватися
	[Arguments]  ${login}  ${password}
	Відкрити вікно авторизації
	Login  ${login}  ${password}
	Перевірити успішність авторизації


Завершити сеанс користувача
	Go To  ${start_page}
	Click Element  ${logout}
	Wait Until Page Does Not Contain Element  ${logout}

