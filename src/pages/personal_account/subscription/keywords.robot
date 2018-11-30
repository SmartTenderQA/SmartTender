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


Перевірити наявність перемикача для активування сповіщень
  ${element}  Set Variable  //*[@class="ivu-row" and contains(., "Періодичність оповіщення про публікацію")]//span[contains(@class, "ivu-switch")]
  Page Should Contain Element  ${element}