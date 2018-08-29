*** Variables ***
${loading}                          css=div.smt-load
${webClient loading}                id=LoadingPanel

*** Keywords ***
Дочекатись закінчення загрузки сторінки
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  180


Дочекатись закінчення загрузки сторінки(skeleton)
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Page Contains Element  css=.skeleton-wrapper  3
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  css=.skeleton-wrapper  180


Дочекатись закінчення загрузки сторінки(webclient)
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Page Contains Element  id=LoadingPanel  3
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  id=LoadingPanel  180
