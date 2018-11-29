*** Variables ***
${window header}           //*[@class="ivu-modal-mask" and not(contains(@style, "display: none"))]/following-sibling::*//*[@class="ivu-modal-header-inner"]


*** Keywords ***
Перевірити наявність всіх елементів в блоці категорії
  Перевірити наявність перемикача для активування сповіщень
  Перевірити наявність блоку підписки  Категорії
  Перевірити наявність блоку підписки  Ключові слова
  Перевірити наявність блоку підписки  Мінус-слова
  Перевірити наявність блоку підписки  Додаткові реквізити
  Перевірити наявність блоку підписки  Реквізити організатора


Перевірити наявність блоку підписки
  [Arguments]  ${text}
  Page Should Contain Element  (//*[@class="ivu-card-body" and contains(., "${text}")])[last()]


Ввести дані в поле E-mail
  [Arguments]  ${mail}
  ${input field}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
  Input Text  ${input field}//input  ${mail}
  Click Element  ${input field}//button


Перевірити наявність перемикача для активування сповіщень
  ${element}  Set Variable  //*[@class="ivu-row" and contains(., "Періодичність оповіщення про публікацію")]//span[contains(@class, "ivu-switch")]
  Page Should Contain Element  ${element}