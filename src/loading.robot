*** Variables ***
${loading}                          css=div.smt-load
${webClient loading}                id=LoadingPanel
${circle loading}                   css=.loading_container .sk-circle
${skeleton loading}                 css=.skeleton-wrapper

*** Keywords ***
Дочекатись закінчення загрузки сторінки
  Дочекатись закінчення загрузки сторінки по елементу  ${loading}


Дочекатись закінчення загрузки сторінки(circle)
  Дочекатись закінчення загрузки сторінки по елементу  ${circle loading}


Дочекатись закінчення загрузки сторінки(skeleton)
  Дочекатись закінчення загрузки сторінки по елементу  ${skeleton loading}


Дочекатись закінчення загрузки сторінки(webclient)
  Дочекатись закінчення загрузки сторінки по елементу  ${webClient loading}


###*** Keywords ***###
Дочекатись закінчення загрузки сторінки по елементу
  [Arguments]  ${locator}
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${locator}  3
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${locator}  180
