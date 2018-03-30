*** Settings ***
Library  Selenium2Library
Library  BuiltIn
Library  DebugLibrary
Library  service.py


*** Variables ***
                                    ###ІНШІ ДАННІ###
${browser}                          chrome
${start_page}                       http://smarttender.biz
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
    #Maximize Browser Window

Login
    [Documentation]  give
    ...     ${user} - login
    ...     and login
    [Arguments]  ${user}
    go to  ${start_page}
    click element  ${events}
    click element  ${login link}
    wait until page contains element  ${login field}
    sleep  2
    ${login}=  get_user_variable  ${user}  login
    Fill login  ${login}
    ${password}=  get_user_variable  ${user}  password
    Fill password  ${password}
    click element  ${login button}
    go to  ${start_page}

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

Find tender
    [Arguments]  ${tender id}
    Go to  ${start_page}
    Sleep  1  #бесит!!!
    Click element  ${komertsiyni-torgy icon}
    Input text  ${field find tender}  ${tender id}
    Press Key  ${field find tender}  \\13
    Open button  ${first element find tender}

Negative
    [Arguments]  ${keyword}
    ${passed}=  Run Keyword And Return Status  ${keyword}
    Should Be Equal  ${passed}  ${False}

Stop if locator absent
    [Documentation]  stop runing keyword if locator absent without 'FAIL'
    [Arguments]  ${locator}
    ${status}=  run keyword and return status  wait until page contains element  ${locator}
    run keyword if  '${status}'!='${True}'  Pass Execution  tadam

Run again
    [Arguments]  ${element}
    run keyword and ignore error  Click element  ${element}
    ${passed}=  Run Keyword And Return Status  wait until page does not contain element  ${element}
    Run keyword if   "${passed}" == "${False}"  Run again  ${element}