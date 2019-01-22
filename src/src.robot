*** Settings ***
Library     Selenium2Library
Library     BuiltIn
Library     Collections
Library	    RequestsLibrary
Library     DebugLibrary
Library     OperatingSystem
Library     String
Library     DateTime


Resource    common/breadcrumbs/breadcrumbs.robot
Resource    common/cdb_api/get_api_data.robot
Resource    common/email/email.robot
Resource    common/header_old/header_old.robot
Resource    common/loading/loading.robot
Resource    common/save_user_session/save_user_session.robot
Resource    common/search/dgf-registry.robot
Resource    common/search/dgf_search.robot
Resource    common/search/new_search.robot
Resource    common/search/old_search.robot
Resource    common/search/small_privatization_search.robot
Library     common/seo/seo.py
Resource    common/synchronization/synchronization.robot
Resource    common/compare_data/compare_data.robot
Resource    common(webclient)/validation/validation.robot


Resource  	elements/actions.robot
Resource  	elements/other.robot


Resource    Faker/faker.robot


Resource    pages/get_auction_href/get_auction_href.robot
Resource    pages/asset_detail_page/asset_detail_page.robot
Resource    pages/auction/auction.robot
Resource    pages/auction_detail_page/auction_detail_page.robot
Resource    pages/blog/blog.robot
Resource    pages/contacts/contacts.robot
Resource    pages/contract/contract.robot
Resource    pages/dozorro/dozorro.robot
Resource    pages/dogovory/dogovory.robot
Resource    pages/EDS/EDS.robot
Resource    pages(webclient)/EDS/EDS_weclient.robot
Resource    pages/guarantee_amount/guarantee_amount.robot
Resource    pages/instruktcii/instruktcii.robot
Resource    pages/karta_saytu/karta_saytu.robot
Resource    pages/komertsiyni_torgy_tender_detail_page/komertsiyni_torgy_tender_detail_page.robot
Resource    pages/kursy_valyut/kursy_valyut.robot
Resource    pages/make_proposal/make_proposal.robot
Resource    pages/nashi_klienty/nashi_klienty.robot
Resource    pages/novyny/novyny.robot
Resource    pages/participation_request/participation_request.robot
Resource    pages/personal_account/personal_account.robot
Resource    pages/personal_account/invoice/invoice.robot
Resource    pages/personal_account/analytics/analytics.robot
Resource    pages/personal_account/legal_help/legal_help.robot
Resource    pages/personal_account/tender_providing/tender_providing.robot
Resource    pages/personal_account/change_password/change_password.robot
Resource    pages/personal_account/company_profile/company_profile.robot
Resource    pages/personal_account/user_profile/user_profile.robot
Resource    pages/personal_account/reports/reports.robot
Resource    pages/personal_account/user_management/user_management.robot
Resource    pages/personal_account/subscription/subscription.robot
Resource    pages/plany/plany.robot
Resource    pages/plany_detail_page/plany_detail_page.robot
Resource    pages/povidomlenya/povidomlenya.robot
Resource    pages/pro_kompaniyu/pro_kompaniyu.robot
Resource    pages/procurement_tender_detail_page/procurement_tender_detail.robot
Resource    pages/procurement_questions/procurement_questions.robot
Resource    pages/procurement_complaints/procurement_complaints.robot
Resource	pages/start_page/start_page.robot
Resource	pages/taryfy/taryfy.robot
Resource    pages/torgy_rialto/torgy_rialto.robot
Resource    pages/vakansii/vakansii.robot
Resource    pages/vidhuky/vidhuky.robot
Resource    pages/zapytannya_i_vidpovidi/zapytannya_i_vidpovidi.robot
Resource    pages/sale/sale_keywords.robot
Resource    pages/sale/SPF/small_privatization/small_privatization_informational_message/small_privatization_informational_message.robot
Resource    pages/sale/SPF/small_privatization/small_privatization_object/small_privatization_object.robot
Resource    pages/sale/SPF/small_privatization/small_privatization_auction/small_privatization_auction.robot
Resource    pages/sale/SPF/dzk/dzk_auction.robot
Resource    pages/sale/SPF/otherAssets/otherAssets.robot
Resource    pages/sale/DGF/dgfAssets/dgfAssets.robot
Resource    pages/sale/DGF/dutch/dutch.robot


Resource    pages(webclient)/desktop/desktop.robot
Resource    pages(webclient)/main_page/actions.robot
Resource    pages(webclient)/main_page/main_page.robot
Resource    pages(webclient)/create_tender/create_tender.robot
Resource    pages(webclient)/create_tender/tender_tab.robot
Resource    pages(webclient)/create_tender/docs_tab.robot
Resource    pages(webclient)/qualification/qualification.robot
Resource    pages(webclient)/second_stage/second_stage.robot
Resource    pages(webclient)/commercial_create_tender/commercial_create_tender.robot
Resource    pages(webclient)/framework_agreement/framework_agreement.robot


Resource    ../steps/Authentication/Authentication.robot
Resource    ../steps/create_tender/sale_dgfAssets.robot
Resource    ../steps/create_tender/below.robot
Resource    ../steps/create_tender/test_dialog.robot
Resource    ../steps/create_tender/test_esco.robot
Resource    ../steps/create_tender/test_open_eu.robot
Resource    ../steps/create_tender/test_open_trade.robot
Resource    ../steps/create_tender/test_ramky.robot
Resource    ../steps/create_tender/dutch_step.robot
Resource    ../steps/create_tender/cdb2_OtherAssets.robot
Resource    ../steps/create_auction/dzk_step.robot
Resource    ../steps/create_auction/small_privatization_step.robot


Resource	keywords.robot
Resource	search.robot
Library		service.py


*** Variables ***
${tab_keybutton}					\\13
${IP}
${user}								test_viewer

${browser}							chrome
${platform}							ANY
${test}                             https://test.smarttender.biz/
${prod}                             https://smarttender.biz/
${hub}                              http://autotest.it.ua:4444/wd/hub

${swt test}							10  # час очікування прогрузки сторінок в секундах для теста
${swt prod}							5	# час очікування прогрузки сторінок в секундах для проду

${block}                            //*[@class='ivu-card ivu-card-bordered']
${error}                            id=loginErrorMsg
${link to make proposal button}     css=[class='show-control button-lot']
${iframe open tender}               //div[@class="container"]/iframe
${make proposal button}             //*[@id="tenderPage"]//a[@class='btn button-lot cursor-pointer']
${make proposal button new}         //*[@id="tenderDetail"]//a[@class="show-control button-lot"]
${derzavni zakupku}                 //*[@id="MainMenuTenders"]//ul[1]/li[2]/a
${bread crumbs}                     (//*[@class='ivu-breadcrumb-item-link'])
${bids search}                      //div[contains(text(), 'Пошук')]/..

${torgy top/bottom tab}              css=#MainMenuTenders ul:nth-child   #up-1 bottom-2
${torgy count tab}                   li:nth-child


*** Keywords ***
Open Browser In Grid
	[Arguments]  ${user}=${user}  ${browser}=${browser}  ${platform}=${platform}
	clear_test_output
	${site}  Отримати дані користувача по полю  ${user}  site
	Set Global Variable  ${site}
	Set Global Variable  ${start_page}  ${${site}}
	Встановити фіксований час очікування прогрузки сторінок  ${site}
	Змінити стартову сторінку для IP
#	${platform}  Evaluate  random.choice(["WIN10", "LINUX"])  random
	Open Browser  ${start_page}  ${browser}  ${user}  ${hub}  platformName:${platform}


Встановити фіксований час очікування прогрузки сторінок
	[Arguments]  ${site}
	Set Global Variable  ${swt}  ${swt ${site}}


Додати першого користувача
    [Arguments]  ${user}
    Open Browser In Grid  ${user}
    Authentication.Авторизуватися  ${user}
    Зберегти сесію  ${user}


Додати користувача
    [Arguments]  ${user}
    Delete All Cookies
	Go To  ${start_page}
	Authentication.Авторизуватися  ${user}
	Зберегти сесію  ${user}


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
	${xpath}  Set Variable  ${xpath.replace("'", '"')}
	${xpath}  Set Variable  ${xpath.replace('xpath=', '')}
	Run Keyword And Ignore Error
	...  Execute JavaScript  document.evaluate('${xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'auto', block: 'center', inline: 'center'});


Clear input By JS
    [Arguments]    ${xpath}
	${xpath}  Set Variable  ${xpath.replace("'", '"')}
	${xpath}  Set Variable  ${xpath.replace('xpath=', '')}
    Execute JavaScript
    ...  document.evaluate('${xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.value=""


Визначити колір елемента
  [Arguments]  ${selector}
  ${elem}  Get Webelement  ${selector}
  ${elem color}  Call Method  ${elem}  value_of_css_property  background-color
  [Return]  ${elem color}


Scroll Page To Top
	Execute JavaScript  window.scrollTo(0,0);


Stop The Whole Test Execution If Previous Test Failed
	Run Keyword If  '${PREV TEST STATUS}' == 'FAIL'  Fatal Error  Ой, щось пішло не так! Вимушена зупинка тесту.


Input Type Flex
  [Arguments]    ${locator}    ${text}
  [Documentation]    write text letter by letter
  ${items}    Get Length    ${text}
  : FOR    ${item}    IN RANGE    ${items}
  \    Press Key    ${locator}    ${text[${item}]}


Дочекатись дати
    [Arguments]  ${date}  ${day_first}=${True}
    ${sleep}=  wait_to_date  ${date}  ${day_first}
    ${count}  Evaluate  int(math.ceil(float(float(${sleep})/float(300))))  math
    Repeat Keyword  ${count} times  Очікування з перезагрузкою сторінки


Очікування з перезагрузкою сторінки
    Sleep  5m
    Reload Page


Очистити Кеш
	Execute Javascript    window.location.reload(true)