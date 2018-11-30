*** Settings ***
Resource    	keywords.robot


*** Variables ***


*** Keywords ***
Перевірити сторінку
  Location Should Contain  /Subscription


Натиснути на кнопку Відправити запит
  Click Element  css=.btn-shadow.ivu-btn-success
  Wait Until Page Contains Element  ${window header}
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


Ввести дані в поле E-mail
  [Arguments]  ${mail}
  ${input field}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
  Input Text  ${input field}//input  ${mail}
  Click Element  ${input field}//button


Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії
  [Arguments]  ${text}
  ${selector}  Set Variable  //*[contains(@class, "ivu-tabs-nav")]//div[contains(@class, "ivu-tabs-tab")]
  ${n}  Run Keyword If  "${text}" == "Публічні закупівлі" or "${text}" == "Аукціони на продаж активів банків"
  ...  Set Variable  2
  ...  ELSE IF  "${text}" == "RIALTO.Закупівлі" or "${text}" == "Аукціони на продаж активів держпідприємств"
  ...  Set Variable  3
  Click Element  ${selector}[${n}]
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${selector}[${n}][contains(@class, "active")]
  Перевірити наявність всіх елементів в блоці категорії
  Run Keyword If  "${status}" != "True"  Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  ${text}


Активувати тип торгів для підписки
  [Arguments]  ${type}
  ${n}  Run Keyword If  "${type}" == "на продаж"  Set Variable  2
  ...  ELSE IF  "${type}" == "на закупівлю"  Set Variable  1
  Set Global Variable  ${tender type cb}  //*[contains(@class, "ivu-row-flex-space-between")]//label[${n}]
  Click Element  ${tender type cb}
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${tender type cb}[contains(@class, "checked")]