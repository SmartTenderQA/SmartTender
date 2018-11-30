*** Keywords ***
Вибрати тип процедури
	[Arguments]  ${type}
	Click Element  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table
	Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '${type}')]
	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table//td[2]//input  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${taken}  ${type}
	Run Keyword If  '${status}' == 'False'  Вибрати тип процедури  ${type}


Зберегти чернетку
    Натиснути додати (додавання тендеру)
	Wait Until Keyword Succeeds  60  2  Ignore WebClient Error  Конфлікт при зверненні
	Run Keyword And Ignore Error  Закрити валідаційне вікно (Так/Ні)  Оголосити закупівлю  Ні


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


Зберегти словник у файл
    [Arguments]  ${dict}  ${filename}
	${json}  conver dict to json  ${dict}
	Create File  ${OUTPUTDIR}/artifact_${filename}.json  ${json}


Вибір об'екту
	${selector}  set Variable  //*[@id="pcModalMode_PW-1"]//span[contains(text(), "Вибір")]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}


Отримати та зберегти tender_id
	${tender_id}  Get Element Attribute  (//tr[contains(@class, 'Row')])[1]//a[not(contains(@href, 'smart'))]  text
	Should Not Be Equal  ${tender_id}  ${EMPTY}
	Set To Dictionary  ${data}  tender_id=${tender_id}


Зберегти пряме посилання на тендер
	${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}





Заповнити поле за допомогою(F10)
	[Arguments]  ${field_name}  ${window_title}  ${choise_text}
	Відкрити вікно(F10)  ${field_name}   ${window_title}
	Вибрати потрібний вид тендера  ${choise_text}
	Підтвердити вибір(F10)
	Перевірити вибір(F10)  ${field_name}  ${choise_text}


Вибрати потрібний вид тендера
	[Arguments]  ${text}
	Click Element  //td[contains(text(), "${text}")]


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


Відкрити сторінку Аукціони ФГВ(test)
	${selector}  Set Variable  //*[contains(text(), 'Аукціони ФГВ(тестові)')]
	Wait Until Page Contains Element  ${selector}  15
	Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки(webclient)


Відкрити сторінку Аукціони ФГВ(prod)
    ${selector}  Set Variable  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
    Wait Until Keyword Succeeds  15  2  Click Element  xpath=//*[contains(text(), 'Аукціони на продаж')]
    Дочекатись закінчення загрузки сторінки(webclient)
    ${status}  Run Keyword And Return Status  Wait Until Keyword Succeeds  15  3  Element Should Be Visible  ${selector}
    Run Keyword If  ${status} == ${true}  Run Keywords
    ...  Wait Until Keyword Succeeds  20  2  Click Element  ${selector}/following::*[contains(text(), 'OK')]
    ...  AND  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  ${selector}


Відкрити сторінку Продаж/Оренда майна(тестові)
	${selector}  Set Variable  //*[contains(text(), 'ProZorro.Продаж') and contains(text(), '(тестові)')]
	Wait Until Page Contains Element  ${selector}  15
	Wait Until Keyword Succeeds  15  2  Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки(webclient)
	Run Keyword If  '${where}' == 'prod'  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
	Run Keyword If  '${where}' == 'prod'  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
	Run Keyword If  '${where}' == 'prod'  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]


Відкрити сторінку для створення публічних закупівель
    Wait Until Page Contains Element  xpath=//*[contains(text(), 'Публічні закупівлі')]  120
    Wait Until Keyword Succeeds  120  3  Натиснути кнопку публічних закупівель
    Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
    Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору')]


Натиснути кнопку публічних закупівель
    Run Keyword And Ignore Error  Click Element  xpath=//*[contains(text(), 'Повторить попытку')]
    Run Keyword And Ignore Error  Click Element  xpath=//*[contains(text(), 'Публічні закупівлі')]
    Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору')]


Відкрити вкладку Гарантійний внесок
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Гарантійний внесок')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Гарантійний внесок


Відкрити вкладку Умови договору оренди
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Умови договору оренди')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Умови договору оренди


Відкрити вкладку Тестовий аукціон
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Тестовий аукціон')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Тестовий аукціон


Змінити мінімальну кількусть учасників
	[Arguments]  ${quantity}
  	Click Element  xpath=//*[contains(text(), 'Мінімальна кількість')]/following-sibling::table
    Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '1')]
  	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Мінімальна кількість')]/following-sibling::table//td[2]//input  value
  	Should Be Equal  ${taken}  ${quantity}
  	Set To Dictionary  ${data}  minimum_number_of_participants  ${quantity}