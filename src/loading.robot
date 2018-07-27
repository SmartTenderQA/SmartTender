*** Variables ***
${loading}                          css=div.smt-load
${webClient loading}                id=LoadingPanel

*** Keywords ***
Дочекатись закінчення загрузки сторінки
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  240