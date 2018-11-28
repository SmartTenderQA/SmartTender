*** Settings ***
Resource  ../common/loading/loading.robot
Resource  cdb1_sale_property.robot
Resource  prod_below.robot
Resource  test_below.robot
Resource  test_dialog.robot
Resource  test_esco.robot
Resource  test_open_eu.robot
Resource  test_open_trade.robot


*** Keywords ***
###############################################
#				Open_Page					  #
###############################################
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


################################################################
#                                                              #
#                     *** Keywords ***                         #
#                                                              #
################################################################
Звебегти дані в файл
	${json}  conver dict to json  ${data}
	Create File  ${OUTPUTDIR}/artifact.json  ${json}


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
