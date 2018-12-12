*** Settings ***
Resource  ../../src/src.robot
Suite Teardown  Close All Browsers

*** Test Cases ***
Start viewer
	Start  test_viewer
	Відкрити сторінку Тарифів
	Зберегти сесію  viewer
	${location}  Get Location
	Log To Console  viewer ${location}


Start provider
	Delete All Cookies
	Go To  ${start_page}
	${login}  ${password}  Отримати дані користувача  user1
	Авторизуватися  ${login}  ${password}
	header_old.Відкрити сторінку інструкцій
	Зберегти сесію  provider
	${location}  Get Location
	Log To Console  provider ${location}


Start tender_owner
	Delete All Cookies
	Go To  ${start_page}
	${login}  ${password}  Отримати дані користувача  Bened
	Авторизуватися  ${login}  ${password}
	Go To  ${start_page}
	Відкрити сторінку Карта сайту
	Зберегти сесію  tender_owner
	${location}  Get Location
	Log To Console  tender_owner ${location}


Check users sessions
	:FOR  ${u}  IN  viewer  provider  tender_owner
	\  Завантажити сесію для  ${u}
	\  ${location}  Get Location
	\  Log To Console  ${u} ${location}
	\  Capture Page Screenshot