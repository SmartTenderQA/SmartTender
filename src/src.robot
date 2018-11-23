*** Settings ***
Library     Selenium2Library
Library     BuiltIn
Library     Collections
Library	    RequestsLibrary
Library     DebugLibrary
Library     OperatingSystem
Library     String
Library     DateTime
Library     service.py
Library     seo.py


Resource  	keywords.robot
Resource    Faker/faker.robot
Resource    EDS.robot
Resource    email.robot
Resource    keywords(webclient).robot
Resource    loading.robot
Resource    pages/login/login.robot
Resource    make_proposal.robot
Resource    participation_request.robot
Resource    search.robot
Resource    common/synchronization/synchronization.robot
Resource    create_tender/keywords.robot
Resource    get_auction_href.robot
Resource    tenders_view.robot
Resource    elements/actions.robot
Resource  	pages/search_small_privatization/search_small_privatization.robot


*** Variables ***
${tab_keybutton}					\\13
${browser}                          chrome
${file path}                        src/
${role}                             None
${IP}
${test}                             https://test.smarttender.biz
${prod}                             https://smarttender.biz

${alies}                              alies
${hub}                                http://autotest.it.ua:4444/wd/hub
${platform}                           ANY
${capability}                         chrome

${block}                            //*[@class='ivu-card ivu-card-bordered']
${error}                            id=loginErrorMsg
${komertsiyni-torgy icon}           //*[@id="main"]//a[2]/img
${link to make proposal button}     css=[class='show-control button-lot']
${iframe open tender}               //div[@class="container"]/iframe
${make proposal button}             //*[@id="tenderPage"]//a[@class='btn button-lot cursor-pointer']
${make proposal button new}         //*[@id="tenderDetail"]//a[@class="show-control button-lot"]
${derzavni zakupku}                 //*[@id="MainMenuTenders"]//ul[1]/li[2]/a
${first element find tender}        //*[@id="tenders"]//tr[1]/td[2]/a
${bread crumbs}                     (//*[@class='ivu-breadcrumb-item-link'])
${bids search}                      //div[contains(text(), 'Пошук')]/..


*** Keywords ***
Start
	[Arguments]  ${user}  ${alies}=alies
	clear_test_output
	${login}  ${password}  Отримати дані користувача  ${user}
	${start_page}  Отримати стартову сторінку  ${site}
	Змінити стартову сторінку для IP
	Open Browser  ${start_page}  ${browser}  ${alies}
	Run Keyword If  "${role}" != "viewer"  Авторизуватися  ${login}  ${password}


Start in grid
	[Arguments]  ${user}  ${alies}=alies
	clear_test_output
	${login}  ${password}  Отримати дані користувача  ${user}
	${start_page}  Отримати стартову сторінку  ${site}
	Змінити стартову сторінку для IP
	Run Keyword If  '${capability}' == 'chrome'    Open Browser  ${start_page}  chrome   ${alies}  ${hub}  platformName:WIN10
	...  ELSE IF    '${capability}' == 'chromeXP'  Open Browser  ${start_page}  chrome   ${alies}  ${hub}  platformName:XP
	...  ELSE IF    '${capability}' == 'firefox'   Open Browser  ${start_page}  firefox  ${alies}  ${hub}
	...  ELSE IF    '${capability}' == 'edge'      Open Browser  ${start_page}  edge     ${alies}  ${hub}
	Run Keyword If  "${role}" != "viewer"  Авторизуватися  ${login}  ${password}


Open button
	[Documentation]   відкривае лінку з локатора у поточному вікні
	[Arguments]  ${selector}
	${href}=  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}


conver dict to json
	[Arguments]  ${dict}
	${json}  evaluate  json.dumps(${dict})  json
	[Return]  ${json}


conver json to dict
	[Arguments]  ${json}
	${dict}  Evaluate  json.loads('''${json}''')  json
	[Return]  ${dict}


Scroll Page To Element XPATH
	[Arguments]    ${xpath}
	Run Keyword And Ignore Error
	...  Execute JavaScript  document.evaluate('${xpath.replace("xpath=", "")}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});
	Run Keyword And Ignore Error
	...  Execute JavaScript  document.evaluate("${xpath.replace('xpath=', '')}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});


Scroll Page To Top
	Execute JavaScript  window.scrollTo(0,0);


Stop The Whole Test Execution If Previous Test Failed
	Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Fatal Error  Ой, щось пішло не так! Вимушена зупинка тесту.


Дочекатись дати
    [Arguments]  ${date}  ${day_first}=${True}
    ${sleep}=  wait_to_date  ${date}  ${day_first}
    Sleep  ${sleep}


##############################################################################
# This shouldn't be here
##############################################################################
Видалити кнопку "Поставити запитання"
	Wait Until Element Is Visible  //div[contains(@class, "widget-button-i24523139185")]
	Execute JavaScript  document.querySelector("div[class*=widget-button-i24523139185]").remove()


Видалити кнопку "Замовити звонок"
	Execute JavaScript  document.getElementById("callback-btn").outerHTML = ""


Дочекатися статусу тендера
	[Arguments]  ${tender status}
	Wait Until Keyword Succeeds  20m  30s  Перевірити статус тендера  ${tender status}


Перевірити статус тендера
    [Arguments]  ${tender_status}
    ${selector}  Set Variable  //*[@data-qa="status"]|//*[@data-qa="auctionStatus"]
    Reload Page
    Wait Until Element Is Visible  ${selector}  20
    ${status}  Get Text  ${selector}
    Should Be Equal  '${status}'  '${tender_status}'

