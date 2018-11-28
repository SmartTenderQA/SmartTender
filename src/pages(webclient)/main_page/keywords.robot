*** Keywords ***
Підтвердити повідомлення про перевірку публікації документу за необхідністю
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  перевірте публікацію Вашого документу
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@title="OK"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)