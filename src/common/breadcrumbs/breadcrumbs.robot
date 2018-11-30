*** Variables ***
${crumb}			(//*[@class='ivu-breadcrumb']/span)/*[1]


*** Keywords ***
Отримати список хлібних крох
	${n}  Порахувати кількість крох
	${list}  Create List
	:FOR  ${i}  IN  ${n}+1
	\  ${text}  Get Text  (${crumb})[${i}]
	\  Append To List  ${list}  ${text}
	[Return]  ${list}


Порахувати кількість крох
	${n}  Get Element Count  ${crumb}
	[Return]  ${n}


Перейти по хлібній крихті за номером
	[Arguments]  ${i}
	${location}  Get Location
	Click Element  (${crumb})[${i}]
	${newlocation}  Get Location
	Should Not Be Equal  ${location}  ${newlocation}

