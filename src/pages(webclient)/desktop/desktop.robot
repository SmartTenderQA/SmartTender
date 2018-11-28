*** Keywords ***
Перейти у розділ (webclient)
    [Arguments]  ${name}
    Click Element  xpath=(//*[@title="${name}"])[1]
    Дочекатись закінчення загрузки сторінки(webclient)



