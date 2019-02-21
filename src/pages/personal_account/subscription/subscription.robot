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


Ввести E-mail для дублювання розсилок
  [Arguments]  ${mail}
  ${input field}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]//input
  Input Text  ${input field}  ${mail}
  Wait Until Keyword Succeeds  15  3  Натиснути на кнопку Додати E-mail для дублювання розсилок


Натиснути на кнопку Додати E-mail для дублювання розсилок
	${input field}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
	Click Element  ${input field}//button
	Element Should Be Focused  ${input field}//button
	Sleep  .5


Видалити E-mail для дублювання розсилок за назвою
	[Arguments]  ${mail}
	${close button}  Set Variable  //*[contains(text(), "${mail}")]/following-sibling::*
	Click Element  ${close button}
	Wait Until Page Does Not Contain Element  ${close button}



Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії
  [Arguments]  ${text}
  ${selector}  Set Variable  //*[contains(@class, "ivu-tabs-nav")]//div[contains(@class, "ivu-tabs-tab")]
  ${n}  Run Keyword If  "${text}" == "Публічні закупівлі" or "${text}" == "Аукціони на продаж активів банків"
  ...  Set Variable  2
  ...  ELSE IF  "${text}" == "RIALTO.Закупівлі" or "${text}" == "Аукціони на продаж активів держпідприємств"
  ...  Set Variable  3
  Click Element  ${selector}\[${n}]
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${selector}\[${n}][contains(@class, "active")]
  Перевірити наявність всіх елементів в блоці категорії
  Run Keyword If  "${status}" != "True"  Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  ${text}


Активувати тип торгів для підписки
  [Arguments]  ${type}
  ${n}  Run Keyword If  "${type}" == "на продаж"  Set Variable  2
  ...  ELSE IF  "${type}" == "на закупівлю"  Set Variable  1
  Set Global Variable  ${tender type cb}  //*[contains(@class, "ivu-row-flex-space-between")]//label[${n}]
  Click Element  ${tender type cb}
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${tender type cb}\[contains(@class, "checked")]


Виконати пошук за реквізитами організатора
  [Arguments]  ${search query}
  ${input selector}  Set Variable  //input[contains(@placeholder, "Введіть назву компанії")]
  Input Text  ${input selector}  ${search_query}
#
  Run Keyword And Ignore Error  Click Element  ${input selector}
# нужно для появления результатов поиска


Перевірити результати пошука за реквізитами організатора
  [Arguments]  ${search query}
  ${result selector}  Set Variable  xpath=//input[contains(@placeholder, "Введіть назву компанії")]/parent::*/following-sibling::*//li[@class="ivu-select-item"]
  Дочекатися відображення елемента на сторінці  ${result selector}  5
  ${result text}  Get Text  ${result selector}
  Should Contain  ${result text.lower()}  ${search query.lower()}

