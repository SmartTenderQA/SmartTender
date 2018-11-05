*** Settings ***
Library     Collections
Resource  ../loading.robot

*** Keywords ***
###############################################
#				Open_Page					  #
###############################################
Відкрити сторінку для створення аукціону на продаж
  Click Element  xpath=//*[contains(text(), 'Аукціони на продаж')]
  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]


Відкрити сторінку Продаж/Оренда майна(тестові)
	${selector}  Set Variable  //*[contains(text(), 'ProZorro.Продажі') and contains(text(), '(тестові)')]
	Wait Until Page Contains Element  ${selector}  15
	Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки(webclient)
	Run Keyword If  '${where}' == 'prod'  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
	Run Keyword If  '${where}' == 'prod'  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
	Run Keyword If  '${where}' == 'prod'  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]


Відкрити сторінку для створення публічних закупівель
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'Публичные закупки')]  120
  Wait Until Keyword Succeeds  120  3  Натиснути кнопку публічних закупівель
  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору')]


Відкрити сторінку заявок на участь в аукціоні
  Wait Until Page Contains Element  //div[contains(@title, 'Заявки на участие в Аукционах')]  120
  Wait Until Keyword Succeeds  120  3  Click Element  //div[contains(@title, 'Заявки на участие в Аукционах')]
  Дочекатись закінчення загрузки сторінки(webclient)
  Element Should Not Be Visible  //div[contains(@title, 'Заявки на участие в Аукционах')]
  Element Should Be Visible  //td[contains(text(), "Заявки на участие в торгах ФГВ")]


Натиснути кнопку публічних закупівель
  Run Keyword And Ignore Error  Click Element  xpath=//*[contains(text(), 'Повторить попытку')]
  Run Keyword And Ignore Error  Click Element  xpath=//*[contains(text(), 'Публичные закупки')]
  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору')]


Відкрити вікно створення тендеру
  Wait Until Keyword Succeeds  30  3  Run Keywords
  ...  Click Element  xpath=//*[contains(text(), 'Додати')]
  ...  AND  Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  AND  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table


Відкрити вкладку Гарантійний внесок
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Гарантійний внесок')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Гарантійний внесок


Відкрити вкладку Тестовий аукціон
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Тестовий аукціон')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Тестовий аукціон


###############################################
#				  Search					  #
###############################################
Пошук об'єкта у webclient по полю
	[Arguments]  ${field}  ${value}
	${find tender field}  Set Variable  xpath=(//tr[@class=' has-system-column'])[1]/td[count(//div[contains(text(), '${field}')]/ancestor::td[@draggable]/preceding-sibling::*)+1]//input
	Click Element  ${find tender field}
	Input Text  ${find tender field}  ${value}
	${get}  Get Element Attribute  ${find tender field}  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
	Run Keyword If  '${status}' == 'False'  Пошук об'єкта у webclient по полю  Номер тендер  ${value}
	Press Key  ${find tender field}  \\13
	Sleep  1


Пошук об'єкта у webclient по полю ФГИ
	[Arguments]  ${field}  ${value}
	${count}  Get Element Count  (//*[@class="gridbox"])[2]//div[contains(text(), "${field}")]/ancestor::td[@draggable]/preceding-sibling::*
	${find tender field}  Set Variable  ((//*[@class="gridbox"])[2]//*[@class=" has-system-column"]//td)[${count}+1]
	Click Element  xpath=${find tender field}//input
	Input Text  xpath=${find tender field}//input  ${value}
	${get}  Get Element Attribute  xpath=${find tender field}//input  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
	Run Keyword If  '${status}' == 'False'  Пошук об'єкта у webclient по полю ФГИ  ${value}  ${field}
	Press Key  xpath=${find tender field}//input  \\13
	Sleep  1


Вибрати тип процедури
	[Arguments]  ${type}
	Click Element  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table
	Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '${type}')]
	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table//td[2]//input  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${taken}  ${type}
	Run Keyword If  '${status}' == 'False'  Вибрати тип процедури  ${type}


Змінити мінімальну кількусть учасників
	[Arguments]  ${quantity}
  	Click Element  xpath=//*[contains(text(), 'Мінімальна кількість')]/following-sibling::table
    Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '1')]
  	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Мінімальна кількість')]/following-sibling::table//td[2]//input  value
  	Should Be Equal  ${taken}  ${quantity}
  	Set To Dictionary  ${data}  minimum_number_of_participants  ${quantity}

###############################################
#				 Fill field					  #
###############################################
Заповнити та перевірити дату старту електронного аукціону
	[Arguments]  ${time}
	${text}  convert_data_for_web_client  ${time}
	# очистити поле с датою
	Click Element  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input
	Click Element  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input/../following-sibling::*
	Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
	# заповнити дату
	Input Text  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input    ${text}
	${got}  Get Element Attribute  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input  value
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
	${text}  convert_data_for_web_client  ${time}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Дата')]/following-sibling::table//input
	# очистити поле с датою
	Click Element  ${selector}
	Click Element  ${selector}/../following-sibling::*
	Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
	# заповнити дату
	Input Text  ${selector}    ${text}
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


################################################################
#                                                              #
#                     *** Keywords ***                         #
#                                                              #
################################################################

################################################################
Заповнити текстове поле
	[Arguments]  ${selector}  ${text}
	Wait Until Keyword Succeeds  30  3  Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Click Element  ${selector}
	Sleep  .5
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Should Be Equal  ${got}  ${text}


Вибрати та повернути елемент у випадаючому списку
	[Arguments]  ${input}  ${selector}
	Click Element  ${input}
	Sleep  .5
	Run Keyword And Ignore Error  Click Element  ${input}/../following-sibling::*
	Sleep  .5
	${count}  Get Element Count  ${selector}
	${number}  random_number  1  ${count}
	Click Element  (${selector})[${number}]
	${text}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${text}
	[Return]  ${text}
################################################################


Звебегти дані в файл
	${json}  conver dict to json  ${data}
	Create File  ${OUTPUTDIR}/artifact.json  ${json}


Зберегти чернетку
	Click Element  xpath=//*[@id='pcModalMode_PW-1']//*[contains(text(), 'Додати')]
	Sleep  3
	Wait Until Element Is Not Visible  ${webClient loading}  120
	Wait Until Element Is Not Visible  xpath=//*[@id='pcModalMode_PW-1']//*[contains(text(), 'Додати')]
	Run Keyword And Ignore Error  Підтвердити збереження чернетки


Підтвердити збереження чернетки
	Wait Until Page Contains  Оголосити закупівлю
	Click Element  xpath=//*[@class="message-box"]//*[.='Ні']
	Дочекатись закінчення загрузки сторінки(webclient)


Оголосити тендер
	Click Element  xpath=//*[@class='dxr-lblContent']/*[contains(text(), 'Надіслати вперед')]
	Дочекатись закінчення загрузки сторінки(webclient)
	${selector}  Set Variable  //*[@class='message-box']//*[contains(text(), 'Так')]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}
	Wait Until Element Is Not Visible  ${selector}
	Дочекатись закінчення загрузки сторінки(webclient)
	${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@id="IMMessageBox_PWH-1T"]
	Run Keyword If  ${status}  Fatal Error  Тендер не опубліковано


Вибір об'екту
	${selector}  set Variable  //*[@id="pcModalMode_PW-1"]//span[contains(text(), "Вибір")]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}


Ignore WebClient Error
	${window}  Set Variable  //*[@id="pcModalMode_PW-1"]//span[contains(text(), "Виняткова ситуація")]
	${OK button}  Set Variable  //*[@id="pcModalMode_PW-1"]//span[contains(text(), "OK")]
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${window}
	Run Keyword If  ${status} == ${True}  Run Keywords
	...  Click Element  ${OK button}
	...  AND  Дочекатись закінчення загрузки сторінки(webclient)
	...  Відкрити сторінку Продаж/Оренда майна(тестові)
