*** Variables ***
${tender found}                     //*[@id="tenders"]/tbody/*[@class="head"]//a[@href and @class="linkSubjTrading"]
${advanced search}                  xpath=//div[contains(text(),'Розширений пошук')]/..
${find tender field}                xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]

${first found element}              //*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading']
${last found multiple element}       xpath=(//*[@id='tenders']//*[@class='head']//span[@class='Multilots']/../..//a[@class='linkSubjTrading'])[last()]
${button komertsiyni-torgy}         css=.with-drop>a[href='/komertsiyni-torgy/']

${torgy top/bottom tab}              css=#MainMenuTenders ul:nth-child   #up-1 bottom-2
${torgy count tab}                   li:nth-child


*** Keywords ***
Знайти тендер по auctionID
  [Arguments]  ${tenderID}
  Виконати пошук тендера  ${tenderID}
  ${tender_href}=  Get Element Attribute  ${tender found}  href
  Go To  ${tender_href}
  Додаткова перевірка на тестові торги для продуктива


Відкрити сторінку тестових торгів
  ${dropdown navigation}  Set Variable  css=#MenuList div.dropdown li>a
  Go To  ${start_page}
  Mouse Over  ${button komertsiyni-torgy}
  Click Element  ${dropdown navigation}[href='/test-tenders/']
  Location Should Contain  /test-tenders/


Зайти на сторінку комерційніх торгів
  ${komertsiyni-torgy icon}  Set Variable  xpath=//*[@id="main"]//a[2]/img
  Click Element  ${komertsiyni-torgy icon}
  Location Should Contain  /komertsiyni-torgy/


Відфільтрувати по формі торгів
  [Arguments]  ${type}=${TESTNAME}
  Розгорнути розширений пошук та випадаючий список видів торгів  ${type}
  Sleep  1
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=//li[contains(@class,'dropdown-item') and text()='${type}']


Відфільтрувати по статусу торгів
	[Arguments]  ${status}
	${dropdown menu for bid statuses}  Set Variable  //label[contains(text(),'Статуси')]/../../ul
	Click Element  ${dropdown menu for bid statuses}
	Click Element  xpath=//li[text()='${status}']


Відфільтрувати по даті кінця прийому пропозиції від
	[Arguments]  ${date}
	${input}  Set Variable  //label[contains(text(),'Завершення прийому')]/../following-sibling::*//input
	Input Text  ${input}  ${date}
	Press Key  ${input}  \\13


Розгорнути розширений пошук та випадаючий список видів торгів
  [Arguments]  ${check from list}=${TESTNAME}
  ${dropdown menu for bid forms}  Set Variable  xpath=//label[contains(text(),'Форми ')]/../../ul
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...       Click Element  ${advanced search}
  ...  AND  Run Keyword And Expect Error  *  Click Element  ${advanced search}
  Sleep  2
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...       Click Element  ${dropdown menu for bid forms}
  ...  AND  Wait Until Page Contains Element  css=.token-input-dropdown-facebook li
  ...  AND  Wait Until Page Contains Element  xpath=//li[contains(@class,'dropdown-item') and text()='${check from list}']


Виконати пошук тендера
  [Arguments]  ${id}=None
  Run Keyword If  '${id}' != 'None'  Input Text  ${find tender field}  ${id}
  Press Key  ${find tender field}  \\13
  Run Keyword If  '${id}' != 'None'  Location Should Contain  f=${id}
  Wait Until Page Contains Element  ${tender found}
  Run Keyword If  '${id}' != 'None'  Перевірити унікальність результату пошуку


Перевірити унікальність результату пошуку
  ${count}  Get Element Count  ${tender found}
  Should Be Equal  '${count}'  '1'


Перейти по результату пошуку
  [Arguments]  ${selector}
  ${href}  Get Element Attribute  ${selector}  href
  ${href}  Поправили лінку для IP  ${href}
  Go To  ${href}
  Виділити iFrame за необхідністю
  Дочекатись закінчення загрузки сторінки(skeleton)


Розгорнути розширений пошук
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...  Click Element  ${advanced search}
  ...  AND  Element Should Be Visible  xpath=//*[@class="dhxform_base"]//*[contains(text(), 'Згорнути пошук')]


Додаткова перевірка на тестові торги для продуктива
	${selector}  Set Variable  //*[@data-qa="title"]|(//h3)[2]
	Wait Until Element Is Visible  //*[@data-qa="title"]|(//h3)[2]  15
	Sleep  1
	${status}  Run Keyword And Return Status  Location Should Contain  test.
	${status2}  Run Keyword If  ${status} == ${False}  Run Keyword And Return Status  Element Should Contain  ${selector}  [ТЕСТУВАННЯ]
	Run Keyword If  ${status2} == ${False}  Fatal Error  це не тестовий тендер [ТЕСТУВАННЯ]
	${tender_id}  Get Text  //h4/following-sibling::a
	Go To  http://smarttender.biz/ws/webservice.asmx/ExecuteEx?calcId=_QA.TEST.GETTENDERMODE&args={"TENDERNUM":"${tender_id}"}&ticket=
	Wait Until Page Contains Element  css=.text
	Element Should Contain  css=.text  test
	Go Back