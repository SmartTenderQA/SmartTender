*** Variables ***
${tender found}                     //*[@id="tenders"]/tbody/*[@class="head"]//a[@href and @class="linkSubjTrading"]
${find tender field}                xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]
${first tender}                     (//tr[@class='evenRow rowselected'])[1]/td[count(//div[contains(text(), 'Номер тендеру')]/ancestor::td[@draggable]/preceding-sibling::*)+1]

${first found element}              //*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading']
${last found multiple element}       xpath=(//*[@id='tenders']//*[@class='head']//span[@class='Multilots']/../..//a[@class='linkSubjTrading'])[last()]

${button komertsiyni-torgy}         css=.with-drop>a[href='/komertsiyni-torgy/']
${dropdown item}                    //li[contains(@class, "dropdown-item")]
${owner block}                      //*[.="Організатори"]


*** Keywords ***
Знайти тендер по ID
	[Arguments]  ${tenderID}
	Виконати пошук тендера  ${tenderID}
	${tender_href}=  Get Element Attribute  ${tender found}  href
	${tender_href}  Поправити лінку для IP  ${tender_href}
	Go To Smart  ${tender_href}
	Log  ${tender_href}  WARN
	Додаткова перевірка на тестові торги для продуктива


Відкрити сторінку тестових торгів
	${location}  Get Location
	Run Keyword If  '${location}' != '${start_page}'  Go To Smart  ${start_page}
	Вибрати елемент з випадаючого списку заголовку  Торговий майданчик  Тестові тендери
	Location Should Contain  /test-tenders/


Перейти по результату пошуку
	[Arguments]  ${selector}
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To Smart  ${href}


Відфільтрувати по організатору
    [Arguments]  ${name}
    Виконати пошук організатора  ${name}
    Click Element     (${dropdown item})[1]
    ${get}  Get Text  (${owner block}/following-sibling::*//li[contains(@class, "input-token-facebook")]//p)[1]
    ${status}  Run Keyword And Return Status   Should Contain  ${get}  ${name}
    Run Keyword If  '${status}' == 'False'  Відфільтрувати по організатору  ${name}


Виконати пошук організатора
    [Arguments]  ${name}
    Input Text  ${owner block}//input  ${name}
    ${status}  Run Keyword And Return Status  elements.Дочекатися відображення елемента на сторінці  (${dropdown item})[1]  30
    Run Keyword If  '${status}' == 'False'  Run Keywords
    ...  Clear Element Text  ${owner block}/ancestor::div[1]//li//input  AND
    ...  Press Key     ${owner block}/ancestor::div[1]//li//input  \\09  AND
    ...  Виконати пошук організатора  ${name}


Відфільтрувати по статусу торгів
	[Arguments]  ${status}
	${dropdown menu for bid statuses}  Set Variable  //label[contains(text(),'Статуси')]/../../ul
	Click Element  ${dropdown menu for bid statuses}
	Wait Until Keyword Succeeds  15  1  Click Element  xpath=//li[text()='${status}']


Відфільтрувати по даті кінця прийому пропозиції від
	[Arguments]  ${date}
	${input}  Set Variable  //label[contains(text(),'Завершення прийому пропозицій')]/../following-sibling::*//input
	Input Text  ${input}  ${date}
	Press Key  ${input}  \\13


Виконати пошук_new
	${search_button}  Set Variable  css=.search-field button
	Wait Until Page Contains Element  ${search_button}
	Click Element  ${search_button}
	Дочекатись закінчення загрузки сторінки


Додаткова перевірка на тестові торги для продуктива
	${selector}  Set Variable  //*[@data-qa="title"]|(//h3)[2]
	elements.Дочекатися відображення елемента на сторінці    ${selector}  45
	Sleep  1
	${test}  Run Keyword And Return Status  Location Should Contain  test.
	${status}  Run Keyword And Return Status  Run Keyword If  ${test} == ${False}  Run Keywords
	...  Element Should Contain  ${selector}  [ТЕСТУВАННЯ]
	...  AND  Перевірити тендер по API на тестовість
	Run Keyword If  ${status} == ${False}  Fatal Error  це не тестовий тендер [ТЕСТУВАННЯ]


Перевірити тендер по API на тестовість
	${tender_id}  Get Text  //h4/following-sibling::a|//*[@data-qa="prozorro-number"]//a
	${location}  Get Location
	Go To Smart  http://smarttender.biz/ws/webservice.asmx/ExecuteEx?calcId=_QA.TEST.GETTENDERMODE&args={"TENDERNUM":"${tender_id}"}&ticket=
	Wait Until Keyword Succeeds  30  3  Page Should Contain Element  css=.text
	Element Should Contain  css=.text  test
	Go To Smart  ${location}
    Wait Until Element Is Visible  //*[@data-qa="title"]|(//h3)[2]  15



