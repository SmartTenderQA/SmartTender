*** Settings ***
Resource    keywords.robot
Resource  	../../common/header_old/header_old.robot

*** Variables ***
${fast_login}			${True}


*** Keywords ***
Авторизуватися
	[Arguments]  ${login}  ${password}
	Run Keyword If  ${fast_login} == ${True}  Run Keywords
	...  Execute JavaScript
	...  jQuery.ajax({
	...  	async:false,
	...  	type:"POST",
	...  	url: "${start_page}/CommonLogin.asmx/Login",
	...  	data:'{"log":"${login}","pass":"${password}","rememberMe":true}',
	...  	dataType: "json",
	...  	contentType:"application/json"
	...  });  AND
	...  Reload Page
	...  ELSE  Run Keywords
	...  Відкрити вікно авторизації  AND
	...  Login  ${login}  ${password}
	Перевірити успішність авторизації


Завершити сеанс користувача
	Go To  ${start_page}
	Натиснути Вийти

