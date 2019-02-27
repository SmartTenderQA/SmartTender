*** Settings ***
Library  save_user_session.py


*** Keywords ***
Зберегти сесію
	[Arguments]  ${user}
	${s}  Get Cookies
    ${cookies}  save_user_session.create_cookies_dict_from_string  ${s}
    Set Global Variable  ${${user}_cookies}  ${cookies}
    ${location}  Get Location
    Set Global Variable  ${${user}_location}  ${location}


Завантажити сесію для
	[Arguments]  ${user}
	${location}  Get Location
	${role}  Отримати дані користувача по полю  ${user}  role
	Set Global Variable  ${role}
	Run Keyword If  "${location}" != "${start_page}"  Go To  ${start_page}
	Delete All Cookies
	:FOR  ${cookie}  IN  @{${user}_cookies.keys()}
	\  ${value}  Get From Dictionary  ${${user}_cookies}  ${cookie}
	\  ${cookie}  Evaluate  '${cookie}'.replace(' ', '')
	\  Add Cookie  ${cookie}  ${value}
	Reload Page
	Go To  ${${user}_location}
	Run Keyword If  '/webclient/' in """${${user}_location}"""  Run Keywords
    ...  Дочекатись закінчення загрузки сторінки  AND
    ...  Location Should Contain  /webclient/
    Run Keyword If  'iis' in "${IP}" and "tender_owner" == "${role}"
    ...  Authentication.Авторизуватися  ${user}