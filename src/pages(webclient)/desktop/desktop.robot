*** Keywords ***
Перейти у розділ (webclient)
    [Arguments]  ${name}
    Click Element  xpath=(//*[@title="${name}"])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Run Keyword And Ignore Error  Закрити валідаційне вікно  Умова відбору тендерів  OK




