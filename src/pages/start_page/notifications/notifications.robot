*** Keywords ***
Отримати інфрмацію повідомлення за номером
	[Arguments]  ${n}=1
	${text}  Get Text  (//*[@data-qa="btn-messages"])[${n}]
	${list}  Split String  ${text}  ${\n}
	${content}  Set Variable  ${list[0]}
	${date}  Set Variable  ${list[1]}
	[Return]  ${content}  ${date}


Натиснути відмітити всі як прочитані
	Click Element  //*[@data-qa='btn-set-all-notifications-viewed']
	Wait Until Keyword Succeeds  10  1  Dot Color Should Be  read


Натиснути показати всі
	Click Element  //*[@data-qa="btn-show-allmessages"]
	# Можливо тут необхідно два послідоовних - Дочекатись закінчення загрузки сторінки
	Дочекатись закінчення загрузки сторінки
	Location Should Contain  /povidomlenya/


###########################################
###########  *** Keywords ***	###########
###########################################
Dot Color Should Be
	[Arguments]  ${status}  ${n}=1
	${read}    Set Variable  rgba(233, 236, 238, 1)
	${unread}  Set Variable  rgba(1, 74, 144, 1)
	${color}  Визначити колір елемента  //*[@class='dot']
	Should Be Equal  ${color}  ${${status}}