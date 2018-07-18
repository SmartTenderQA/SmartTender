*** Variables ***
${CSK}          xpath=//*[contains(text(), 'ЦСК')]/../following-sibling::*/select
${iframe}       xpath=//*[@class="ivu-modal-wrap"]//iframe
${passwod}      291263

*** Keywords ***
Перевірити можливість підписання ЕЦП для позову
  [Documentation]  ${selector} should be end as //*[contains(text(), 'Підписати ЕЦП')]
  [Arguments]  ${selector}
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa="monitoring-appeal-description"]/../following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
  Click Element  ${selector}
  Select Frame  ${iframe}
  Wait Until Page Does Not Contain Element  ${CSK}  120
  Вибрати тестовий ЦСК
  Завантажити ключ
  Ввести пароль ключа
  Натиснути Підписати
  Закрити вікно з ЕЦП


Перевірити успішність підписання ЕЦП
  [Arguments]  ${selector}
  Page Should Contain Element  ${selector}/../following-sibling::*//*[contains(text(), 'sign.p7s')]


Вибрати тестовий ЦСК
  Sleep  1
  Click Element  ${CSK}/option[contains(text(), 'Тестовий ЦСК АТ "ІІТ"')]


Завантажити ключ
  Choose File  css=.filecontainer input.upload  ${EXECDIR}/Key-6.dat


Ввести пароль ключа
  Input Text  css=input[type=PASSWORD]  ${passwod}


Натиснути Підписати
  Click Element  xpath=//*[@role='link']//*[contains(text(), 'Підписати')]/..
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'ЕЦП успішно')]//*[contains(text(), 'накладено!')]  120


Закрити вікно з ЕЦП
  Reload Page