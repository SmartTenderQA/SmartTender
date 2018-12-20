*** Variables ***
${tender found}                     //*[@id="tenders"]/tbody/*[@class="head"]//a[@href and @class="linkSubjTrading"]
${find tender field}                xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]
${first tender}                     (//tr[@class='evenRow rowselected'])[1]/td[count(//div[contains(text(), 'Номер тендеру')]/ancestor::td[@draggable]/preceding-sibling::*)+1]

${first found element}              //*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading']
${last found multiple element}       xpath=(//*[@id='tenders']//*[@class='head']//span[@class='Multilots']/../..//a[@class='linkSubjTrading'])[last()]

${button komertsiyni-torgy}         css=.with-drop>a[href='/komertsiyni-torgy/']

*** Keywords ***
Знайти тендер по ID
  [Arguments]  ${tenderID}
  Виконати пошук тендера  ${tenderID}
  ${tender_href}=  Get Element Attribute  ${tender found}  href
  Go To  ${tender_href}
  Log  ${tender_href}  WARN
  Додаткова перевірка на тестові торги для продуктива


Відкрити сторінку тестових торгів
  ${dropdown navigation}  Set Variable  css=#MenuList div.dropdown li>a
  Go To  ${start_page}
  Mouse Over  ${button komertsiyni-torgy}
  Wait Until Keyword Succeeds  10  1  Click Element  ${dropdown navigation}[href='/test-tenders/']
  Location Should Contain  /test-tenders/


Перейти по результату пошуку
  [Arguments]  ${selector}
  ${href}  Get Element Attribute  ${selector}  href
  ${href}  Поправити лінку для IP  ${href}
  Go To  ${href}
  Дочекатись закінчення загрузки сторінки(skeleton)



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


Виконати пошук_new
	${search_button}  Set Variable  css=.search-field button
	Wait Until Page Contains Element  ${search_button}
	Click Element  ${search_button}
	Дочекатись закінчення загрузки сторінки(skeleton)


Додаткова перевірка на тестові торги для продуктива
	${selector}  Set Variable  //*[@data-qa="title"]|(//h3)[2]
	Wait Until Element Is Visible  //*[@data-qa="title"]|(//h3)[2]  15
	Sleep  1
	${test}  Run Keyword And Return Status  Location Should Contain  test.
	${status}  Run Keyword And Return Status  Run Keyword If  ${test} == ${False}  Run Keywords
	...  Element Should Contain  ${selector}  [ТЕСТУВАННЯ]
	...  AND  Перевірити тендер по API на тестовість
	Run Keyword If  ${status} == ${False}  Fatal Error  це не тестовий тендер [ТЕСТУВАННЯ]


Перевірити тендер по API на тестовість
	${tender_id}  Get Text  //h4/following-sibling::a|//*[@data-qa="prozorro-number"]//a
	${location}  Get Location
	Go to  http://smarttender.biz/ws/webservice.asmx/ExecuteEx?calcId=_QA.TEST.GETTENDERMODE&args={"TENDERNUM":"${tender_id}"}&ticket=
	Wait Until Keyword Succeeds  30  3  Page Should Contain Element  css=.text
	Element Should Contain  css=.text  test
	Go to  ${location}
    Wait Until Element Is Visible  //*[@data-qa="title"]|(//h3)[2]  15



