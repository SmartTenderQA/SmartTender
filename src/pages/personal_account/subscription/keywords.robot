*** Variables ***
${window header}           //*[@class="ivu-modal-mask" and not(contains(@style, "display: none"))]/following-sibling::*//*[@class="ivu-modal-header-inner"]


*** Keywords ***
Натиснути на кнопку Відправити запит
  Click Element  css=.btn-shadow.ivu-btn-success
  Wait Until Page Contains Element  ${window header}


Перевірити вікно Запит налаштування підписки
  Element Should Contain  ${window header}  Запит налаштування підписки


Закрити вікно Запит налаштування підписки
  ${close button}  Set Variable  //*[@class="ivu-modal-mask" and not(contains(@style, "display: none"))]/following-sibling::*//*[contains(@class, "ivu-icon-ios-close-empty")]
  Click Element  ${close button}
  Wait Until Page Does Not Contain Element  ${close button}



Перевірити заголовок Персональне запрошення організатора
  ${element}  Set Variable  (//h4)[2]
  Element Should Contain  ${element}  Персональне запрошення організатора


Перевірити перемикач Персональне запрошення організатора
  ${switcher}  Set Variable  //*[@class="ivu-card-body" and contains(., "Персональне запрошення організатора")]//*[@tabindex]
  ${status}  Get Element Attribute  ${switcher}/input  Value
  Wait Until Keyword Succeeds  10  1  Click Element  ${switcher}
  ${new_status}  Get Element Attribute  ${switcher}/input  Value
  Should Not Be Equal  ${new_status}  ${status}


Перевірити заголовок E-mail адреси для дублювання всіх розсилок
  ${element}  Set Variable  (//h4)[3]
  Element Should Contain  ${element}  E-mail адреси для дублювання всіх розсилок


Перевірити поле вводу E-mail адреси для дублювання всіх розсилок
  ${input field}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
  ${mail}  create_e-mail
  Input Text  ${input field}//input  ${mail}
  Click Element  ${input field}//button
  Page Should Contain  ${mail}
  ${close button}  Set Variable  //*[contains(text(), "${mail}")]/following-sibling::*
  Click Element  ${close button}
  Wait Until Page Does Not Contain Element  ${close button}


Перевірити поле вводу E-mail адреси для дублювання всіх розсилок(negative)
  ${element}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
  ${n}  random_number  4  20
  ${name}  Generate Random String  ${n}  [LOWER]
  Input Text  ${element}//input  ${name}
  Click Element  ${element}//button
  Wait Until Element Contains  css=.ivu-message-notice span  Неправильний формат електронної пошти


Перевірити наявність всіх елементів в блоці категорії
  Перевірити наявність перемикача для активування сповіщень
  Перевірити наявність блоку підписки  Категорії
  Перевірити наявність блоку підписки  Ключові слова
  Перевірити наявність блоку підписки  Мінус-слова
  Перевірити наявність блоку підписки  Додаткові реквізити
  Перевірити наявність блоку підписки  Реквізити організатора


Вибрати вкладку для підписки
  [Arguments]  ${text}
  ${selector}  Set Variable  //*[contains(@class, "ivu-tabs-nav")]//div[contains(@class, "ivu-tabs-tab")]
  ${n}  Run Keyword If  "${text}" == "Публічні закупівлі" or "${text}" == "Аукціони на продаж активів банків"
  ...  Set Variable  2
  ...  ELSE IF  "${text}" == "RIALTO.Закупівлі" or "${text}" == "Аукціони на продаж активів держпідприємств"
  ...  Set Variable  3
  Click Element  ${selector}[${n}]
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${selector}[${n}][contains(@class, "active")]
  Run Keyword If  "${status}" != "True"  Вибрати вкладку для підписки  ${text}


Перевірити наявність блоку підписки
  [Arguments]  ${text}
  Page Should Contain Element  (//*[@class="ivu-card-body" and contains(., "${text}")])[last()]


Вибрати тип торгів
  [Arguments]  ${type}
  ${n}  Run Keyword If  "${type}" == "на продаж"  Set Variable  2
  ...  ELSE IF  "${type}" == "на закупівлю"  Set Variable  1
  Set Global Variable  ${tender type cb}  //*[contains(@class, "ivu-row-flex-space-between")]//label[${n}]
  Click Element  ${tender type cb}


Перевірити тип торгів
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${tender type cb}[contains(@class, "checked")]