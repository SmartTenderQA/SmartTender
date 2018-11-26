*** Keywords ***
Статус тендера повинен бути
    [Arguments]  ${status should}
    ${status is}  Отрымати статус тендера
    Should Be Equal  '${status should}'  '${status is}'