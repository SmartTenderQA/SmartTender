*** Keywords ***
Отримати
	[Arguments]  ${text}
	${dict}  Create Dictionary
	...  організацію=title-menu-user-organization
	...  фио=title-menu-user-fio
	...  login=title-menu-user-login
	${selector}  Set Variable
	...  //*[@data-qa="${dict[u'${text}']}"]
	${get}  Get Text  ${selector}
	[Return]  ${get}


Натиснути
	[Arguments]  ${text}
	${dict}  Create Dictionary
	...  Особистий кабінет=title-menu-user-personal-area
	...  Управління користувачами=title-menu-user-user-management
	...  Змінити пароль=title-menu-user-change-password
	...  Вийти=title-menu-user-exit
	${selector}  Set Variable
	...  //*[@data-qa="${dict[u'${text}']}"]
	Click Element  ${selector}
	Run Keyword  Перевірити виконання дії після натискання ${text}


###########################################
###########  *** Keywords ***	###########
###########################################
Перевірити виконання дії після натискання Особистий кабінет
	Run Keyword  Перевірити виконання дії після натискання Особистий кабінет для ${role}


Перевірити виконання дії після натискання Особистий кабінет для provider
	Дочекатись закінчення загрузки сторінки
	Location Should Contain  /webparts/
	Page Should Contain Element  css=.sidebar-menu
	Page Should Contain Element  css=.main-content


Перевірити виконання дії після натискання Особистий кабінет для tender_owner
	Дочекатись закінчення загрузки сторінки
	Location Should Contain  /webclient/


Перевірити виконання дії після натискання Особистий кабінет для ssp_tender_owner
	Location Should Contain  /cabinet/registry/privatization-objects
	Page Should Contain Element  css=.action-block [type="button"]
	Page Should Contain Element  css=.content-block .asset-card


Перевірити виконання дії після натискання Управління користувачами
	No Operation


Перевірити виконання дії після натискання Змінити пароль
	Location Should Contain  /Authentication/ChangePassword/


Перевірити виконання дії після натискання Вийти
	Дочекатись закінчення загрузки сторінки
	Page Should Not Contain  ${name}
	Page Should Contain Element  ${log in button}
