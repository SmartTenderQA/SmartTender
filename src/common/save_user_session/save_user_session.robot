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
	Delete All Cookies
	:FOR  ${cookie}  IN  @{${user}_cookies.keys()}
	\  ${value}  Get From Dictionary  ${${user}_cookies}  ${cookie}
	\  Add Cookie  ${cookie}  ${value}
	Reload Page
	${location}  Get Location
	Run Keyword If  "${location}" != "${${user}_location}"  Go To  ${${user}_location}
	${status}  Run Keyword And Return Status  Should Contain  """${${user}_location}"""  /webclient/
    Run Keyword If  ${status}  Run Keywords
    ...  Дочекатись закінчення загрузки сторінки  AND
    ...  Location Should Contain  /webclient/