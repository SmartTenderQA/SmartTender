*** Keywords ***
Вибрати тип процедури
	[Arguments]  ${type}
	Click Element  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table
	Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '${type}')]
	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table//td[2]//input  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${taken}  ${type}
	Run Keyword If  '${status}' == 'False'  Вибрати тип процедури  ${type}


Заповнити текстове поле
	[Arguments]  ${selector}  ${text}
	Wait Until Keyword Succeeds  30  3  Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Click Element  ${selector}
	Sleep  .5
	Clear Element Text  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Be Equal  ${got}  ${text}


Вибрати та повернути елемент у випадаючому списку
	[Arguments]  ${input}  ${selector}
	Click Element  ${input}
	Sleep  .5
	Run Keyword And Ignore Error  Click Element  ${input}/../following-sibling::*
	Sleep  .5
	Wait Until Page Contains Element  ${selector}  15
	${count}  Get Element Count  ${selector}
	${number}  random_number  1  ${count}
	Click Element  (${selector})[${number}]
	${text}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${text}
	[Return]  ${text}


Заповнити Поле
    [Arguments]  ${selector}  ${text}
    Wait Until Page Contains Element  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Input Text  ${selector}  ${text}
    Sleep  .5
    Press Key  ${selector}  \\09
    Sleep  1


###############################################
#				 Fill field					  #
###############################################
Заповнити та перевірити поле с датою
	[Arguments]  ${field_name}  ${time}
	${text}  Run Keyword If  "${site}" == "prod"  convert_data_for_web_client  ${time}
	...  ELSE IF  "${site}" == "test"  Set Variable  ${time}
	# очистити поле с датою
	Click Element  xpath=//*[contains(text(), '${field_name}')]/following-sibling::table//input
	Click Element  xpath=//*[contains(text(), '${field_name}')]/following-sibling::table//input/../following-sibling::*
	Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
#	заповнити дату
	Input Text  xpath=//*[contains(text(), '${field_name}')]/following-sibling::table//input    ${text}
	${got}  Get Element Attribute  xpath=//*[contains(text(), '${field_name}')]/following-sibling::table//input  value
	Press Key  xpath=//*[contains(text(), '${field_name}')]/following-sibling::table//input  \\13
	Should Be Equal  ${got}  ${time}


Заповнити та перевірити мінімальний крок аукціону
	[Arguments]  ${minimal_step_percent}
	${selector}  Set Variable  xpath=(//*[contains(text(), 'Мінімальний крок аукціону')]/following-sibling::table)[2]//input
	Click Element  ${selector}
	Input Text  ${selector}  ${minimal_step_percent}
	Press Key  ${selector}  \\13
	${got}  Get Element Attribute  ${selector}  value
	${got}  Evaluate  str(int(${got}))
	Should Be Equal  ${got}  ${minimal_step_percent}


Заповнити та перевірити дату Рішення Дирекції
	[Arguments]  ${time}
	${text}  Run Keyword If  "${site}" == "prod"  convert_data_for_web_client  ${time}
	...  ELSE IF  "${site}" == "test"  Set Variable  ${time}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Дата')]/following-sibling::table//input
	# очистити поле с датою
	Click Element  ${selector}
	Click Element  ${selector}/../following-sibling::*
	Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
	# заповнити дату
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Should Be Equal  ${got}  ${time}


Заповнити та перевірити гарантійний внесок
  	[Arguments]  ${percent}
  	${selector}  Set Variable  xpath=//*[@data-name="GUARANTEE_AMOUNT_PERCENT"]//input
  	Input Text  ${selector}  ${percent}
  	Press Key  ${selector}  \\13
  	${got}  Get Element Attribute  ${selector}  value
  	${got}  Evaluate  str(int(${got}))
  	Should Be Equal  ${got}  ${percent}