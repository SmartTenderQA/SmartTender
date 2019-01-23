*** Variables ***
${instruktcii field}					(//*[@class='ivu-card-body'])[1]//span[2]
${instruktcii from dropdown menu}		(//*[@class='ivu-card-body'])[1]//ul/li[@class]
${instruktcii item}						//*[@class="ivu-row"]//div//*[contains(@class, 'item')]


*** Keywords ***
Вибрати з видаючого списку
	[Arguments]  ${text}
	Click Element  ${instruktcii field}
	${n}  Run Keyword If
	...  '${text}' == 'Показати всі'  					Set Variable  1				ELSE IF
	...  '${text}' == 'Інструкції загального напрямку'  Set Variable  2				ELSE IF
	...  '${text}' == 'Інструкції для організатора'		Set Variable  3				ELSE IF
	...  '${text}' == 'Інструкції для учасника'			Set Variable  4
	Click Element  ${instruktcii from dropdown menu}[${n}]
	Wait Until Keyword Succeeds  10  1  Element Should Contain  ${instruktcii field}  ${text}


Порахувати кількість інструкції
	${n}  Get Element Count  ${instruktcii item}
	[Return]  ${n}
