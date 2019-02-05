*** Variables ***
${pass}          29121963
${ca list}       //select[@name="ca"]
${upload}        (//*[@id="eds_placeholder"]//input[@class="upload"])[1]
${pass input}    //*[@id="eds_placeholder"]//input[@name="password"]
${sign btn}      //*[@id="eds_placeholder"]//*[contains(@class,"btn")][text()="Підписати"]
${eds index}     0


*** Keywords ***
Накласти ЕЦП (webclient)
    loading.Дочекатись закінчення загрузки сторінки(webclient)
    Run Keyword If      '${eds index}' != '1'  Накласти ЕЦП (webclient) перший раз
    Set Global Variable  ${eds index}  1
    loading.Дочекатись закінчення загрузки сторінки(webclient)
    validation.Підтвердити повідомлення про перевірку публікації документу за необхідністю


Накласти ЕЦП (webclient) перший раз
    Wait Until Element Is Visible  //label[text()="ЦСК"]  20
    Select From List By Label      ${ca list}     Тестовий ЦСК АТ "ІІТ"
    Choose File                    ${upload}      ${EXECDIR}/src/pages(webclient)/EDS/Key-6.dat
    Input Password                 ${pass input}  ${pass}
    Click Element                  ${sign btn}
    loading.Дочекатись закінчення загрузки сторінки(webclient)
    validation.Підтвердити повідомлення про перевірку публікації документу за необхідністю
