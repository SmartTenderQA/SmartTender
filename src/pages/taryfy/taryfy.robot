*** Variables ***
${taryfy iframe}  					css=iframe
${taryfy text}                      //a[@data-toggle="tab"]


*** Keywords ***
Перевірити кількість закладок
	Select Frame  ${taryfy iframe}
	${count}  Get Element Count  ${taryfy text}
	Run Keyword if  '${count}' != '4'  Fail  Не вірна кількість закладок тарифів
	Unselect Frame


Активувати вкладку
	[Arguments]  ${text}
	Select Frame  ${taryfy iframe}
	${n}  Run Keyword If
	...  '${text}' == 'Публічні закупівлі ProZorro та торги RIALTO'  			Set Variable  1  ELSE IF
	...  '${text}' == 'Комерційні торги'  										Set Variable  2  ELSE IF
	...  '${text}' == 'Продаж активів банків, що ліквідуються (ФГВФО)'  		Set Variable  3  ELSE IF
	...  '${text}' == 'Продаж і оренда майна/активів Державних підприємств'  	Set Variable  4
	Click Element  ${taryfy text}[${n}]
	Page Should Contain Element  ${taryfy text}[${n}][@class="active"]
	${is}  Get Text  ${taryfy text}[${n}]
	Should Be Equal  ${is}  ${text}
	Unselect Frame
