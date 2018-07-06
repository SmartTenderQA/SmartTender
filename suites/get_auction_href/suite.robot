*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//div[@class='row']//a[contains(@class, 'button')]
${start_page}                       http://smarttender.biz
${webClient loading}                id=LoadingPanel


*** Test Cases ***
Створити тендер
  Відкрити сторінку для створення тендеру
  Відкрити вікно створення тендеру
  Вибрати тип процедури  Голландський аукціон
  Заповнити дату старту електронного аукціону
  Заповнити ціну
  Заповнити мінімальний крок аукціону
  dgfDecisionID

*** Keywords ***
Відкрити вікна для всіх користувачів
  Open Browser  ${start_page}  ${browser}  alias=tender_owner
  Login  fgv_prod_owner
  Go Back
  #Open Browser  ${start_page}  ${browser}  alias=viewer
  #Open Browser  ${start_page}  ${browser}  alias=provider1
  #Login  test_it.ua
  ${data}  Create Dictionary
  Set Global Variable  ${data}


Відкрити сторінку для створення тендеру
  Switch Browser  tender_owner
  Sleep  5
  Click Element  xpath=//*[contains(text(), 'Аукціони на продаж')]
  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
  Click Element  xpath=//*[contains(text(), 'OK')]
  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]


Відкрити вікно створення тендеру
  Click Element  xpath=//*[contains(text(), 'Додати')]
  Wait Until Element Is Not Visible  ${webClient loading}  120
  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table


Вибрати тип процедури
  [Arguments]  ${type}
  Click Element  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table
  Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '${type}')]
  ${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table//td[2]//input  value
  Should Be Equal  ${taken}  ${type}


Заповнити дату старту електронного аукціону
  ${time}  get_time  1
  ${text}  convert_data_for_web_client  ${time}
  ${auctionPeriod}  Create Dictionary  startDate=${time}
  Set To Dictionary  ${data}  auctionPeriod=${auctionPeriod}
  Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату старту електронного аукціону  ${text}


Заповнити та перевірити дату старту електронного аукціону
  [Arguments]  ${time}
  # очистити поле с датою
  Click Element  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input
  Click Element  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input/../following-sibling::*
  Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
  # заповнити дату
  Input Text  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input    ${time}
  ${got}  Get Element Attribute  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input  value
  Should Be Equal  ${got}  ${time}


Заповнити ціну
  ${amount}  random_number  100000  100000000
  ${value}  Create Dictionary  amount=${amount}
  Set To Dictionary  ${data}  value=${value}
  Wait Until Keyword Succeeds  120  3  Заповинити та перевірити ціну  ${amount}


Заповинити та перевірити ціну
  [Arguments]  ${amount}
  ${selector}  Set Variable  xpath=//*[contains(text(), 'Ціна')]/following-sibling::table//input
  Input Text  ${selector}  ${amount}
  ${got}  Get Element Attribute  ${selector}  value
  Should Be Equal  ${got}  ${amount}


Заповнити мінімальний крок аукціону
  ${minimal_step_percent}  random_number  1  5
  Set To Dictionary  ${data.value}  minimal_step_percent=${minimal_step_percent}
  Wait Until Keyword Succeeds  120  3  Заповнити та перевірити мінімальний крок аукціону  ${minimal_step_percent}


Заповнити та перевірити мінімальний крок аукціону
  [Arguments]  ${minimal_step_percent}
  ${selector}  Set Variable  xpath=(//*[contains(text(), 'Мінімальний крок аукціону')]/following-sibling::table)[2]//input
  Input Text  ${selector}  ${minimal_step_percent}
  Press Key  ${selector}  \\13
  ${got}  Get Element Attribute  ${selector}  value
  Should Be Equal  ${got}  ${minimal_step_percent}



Suite Postcondition
  Close All Browsers

