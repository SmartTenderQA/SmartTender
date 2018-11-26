*** Settings ***
Resource    	keywords.robot


*** Keywords ***
Перевірка гарантійного внеску
	${data}  Отримати дані тендеру з cdb по id
	${multiple_status}  Run Keyword And Return Status  Get From Dictionary  ${data['data']['lots'][1]}  title
	${multiple_status_guarantee}  Run Keyword And Return Status  Get From Dictionary  ${data['data']['lots'][1]}  guarantee
	Run Keyword If
	...  "${multiple_status_guarantee}" == "True"  	Перевірка гарантійного внеску для мультилоту  			ELSE IF
	...  "${multiple_status}" == "False"  			Перевірка гарантійного внеску для не мультилоту