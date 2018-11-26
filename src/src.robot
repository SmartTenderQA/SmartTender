*** Settings ***
Library     Selenium2Library
Library     BuiltIn
Library     Collections
Library	    RequestsLibrary
Library     DebugLibrary
Library     OperatingSystem
Library     String
Library     DateTime


Resource    common/email/email.robot
Resource    common/get_auction_href/get_auction_href.robot
Resource    common/header_old/header_old.robot
Resource    common/loading/loading.robot
Library     common/seo/seo.py
Resource    common/synchronization/synchronization.robot


Resource  	elements/webclient/webclient_elements.robot
Resource  	elements/actions.robot
Resource  	elements/other.robot


Resource    create_tender/keywords.robot


Resource    elements/actions.robot
Resource    elements/webclient/webclient_elements.robot


Resource    Faker/faker.robot


Resource    pages/auction/auction.robot
Resource    pages/EDS/EDS.robot
Resource    pages/invoice/invoice.robot
Resource    pages/login/login.robot
Resource    pages/make_proposal/make_proposal.robot
Resource    pages/participation_request/participation_request.robot
Resource    pages/povidomlenya/povidomlenya.robot
Resource    pages/procurement_tender_detail_page/procurement_tender_detail.robot
Resource	pages/search_small_privatization/search_small_privatization.robot
Resource	pages/start_page/start_page.robot


Resource    get_auction_href.robot
Resource    keywords(webclient).robot
Resource	keywords.robot
Resource	search.robot
Library		service.py


*** Variables ***
${tab_keybutton}					\\13
${browser}							chrome
${file path}						src/
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

