*** Settings ***
Library  Selenium2Library
Library  BuiltIn
Library  DebugLibrary
Library  service.py


*** Variables ***
                                    ###ІНШІ ДАННІ###
${browser}                          chrome
${start_page}                       http://test.smarttender.biz
${file path}                        src/
${some text}                        Це_тестовый_текст_для_тестування._Це_тестовый_текст_для_тестування._Це_тестовый_текст_для_тестування.

                                    ###ЛОКАТОРИ###
${login button}                     xpath=//*[@id="loginForm"]/button[2]
${logout}                           id=LogoutBtn
${login link}                       id=SignIn
${events}                           xpath=//*[@id="LoginDiv"]//a[2]
${login field}                      id=login
${password field}                   id=password
${error}                            id=loginErrorMsg

${iframe open tender}               xpath=.//div[@class="container"]/iframe
${make proposal button}             xpath=//*[@id="tenderPage"]//a[@class='btn button-lot cursor-pointer']
${make proposal button new}         xpath=//*[@id="tenderDetail"]//a[@class="show-control button-lot"]
${komertsiyni-torgy icon}           xpath=//*[@id="main"]//a[2]/img
${derzavni zakupku}                 xpath=//*[@id="MainMenuTenders"]//ul[1]/li[2]/a
${first element find tender}        xpath=//*[@id="tenders"]//tr[1]/td[2]/a

${loading}                          css=.smt-load .box


*** Keywords ***
Start
  Open Browser  ${start_page}  ${browser}  alies

Login
  [Arguments]  ${user}
  Go To  ${start_page}
  Click Element  ${events}
  Click Element  ${login link}
  Sleep  2
  ${login}=  get_user_variable  ${user}  login
  Fill Login  ${login}
  ${password}=  get_user_variable  ${user}  password
  Fill Password  ${password}
  Click Element  ${login button}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  60
  ${name}=  get_user_variable  ${user}  name
  Wait Until Page Contains  ${name}  10
  Go To  ${start_page}

Fill login
  [Arguments]  ${user}
  Input Text  ${login field}  ${user}

Fill password
  [Arguments]  ${pass}
  Input Text  ${password field}  ${pass}

Open button
  [Documentation]   відкривае лінку з локатора у поточному вікні
  [Arguments]  ${selector}
  ${a}=  Get Element Attribute  ${selector}  href
  Go To  ${a}