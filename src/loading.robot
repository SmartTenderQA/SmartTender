*** Variables ***
${loading}                          css=div.smt-load
${webClient loading}                //*[contains(@class, 'LoadingPanel')]
${circle loading}                   css=.loading_container .sk-circle
${skeleton loading}                 css=.skeleton-wrapper
${sales spin}                       css=.ivu-spin
${docs spin}                        //div[contains(@style, "loading")]

*** Keywords ***
Дочекатись закінчення загрузки сторінки
  Дочекатись закінчення загрузки сторінки по елементу  ${loading}


Дочекатись закінчення загрузки сторінки(circle)
  Дочекатись закінчення загрузки сторінки по елементу  ${circle loading}


Дочекатись закінчення загрузки сторінки(skeleton)
  Дочекатись закінчення загрузки сторінки по елементу  ${skeleton loading}


Дочекатись закінчення загрузки сторінки(webclient)
  Дочекатись закінчення загрузки сторінки по елементу  ${webClient loading}


Дочекатись закінчення загрузки сторінки(sales spin)
  Дочекатись закінчення загрузки сторінки по елементу  ${sales spin}


Дочекатись загрузки документів в тендері
  Дочекатись закінчення загрузки сторінки по елементу  ${docs spin}


###*** Keywords ***###
Дочекатись закінчення загрузки сторінки по елементу
  [Arguments]  ${locator}
  ${status}  ${message}  Run Keyword And Ignore Error
  ...  Wait Until Element Is Visible
  ...  ${locator}
  ...  3
  Run Keyword If  "${status}" == "PASS"
  ...  Run Keyword And Ignore Error
  ...  Wait Until Element Is Not Visible
  ...  ${locator}
  ...  120
  Run Keyword If  "${status}" == "PASS"
  ...  Дочекатись закінчення загрузки сторінки по елементу
  ...  ${locator}
