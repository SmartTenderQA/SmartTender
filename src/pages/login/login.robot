*** Settings ***
Resource    keywords.robot
Resource  	../../common/header_old/header_old.robot


*** Keywords ***
Авторизуватися
	[Arguments]  ${login}  ${password}
	Відкрити вікно авторизації
	Login  ${login}  ${password}
	Перевірити успішність авторизації


Завершити сеанс користувача
	Go To  ${start_page}
	Натиснути Вийти

