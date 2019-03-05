*** Keywords ***
Видалити кнопку "Поставити запитання"
	Wait Until Page Contains Element  //div[contains(@class, "widget-button-i24523139185")]
	Execute JavaScript  document.querySelector("div[class*=widget-button-i24523139185]").remove()


Видалити кнопку "Замовити звонок"
    Wait Until Page Contains Element  //*[@id="callback-btn"]
	Execute JavaScript  document.getElementById("callback-btn").outerHTML = ""


Закрити сповіщення "Берете участь вперше?"
	${status}  run keyword and return status  elements.Дочекатися відображення елемента на сторінці
	...  //*[@class="ivu-notice-title"][text()="Берете участь вперше?"]  2
	run keyword if  ${status}  run keywords
	...  click element  //button[text()="Я ознайомлений"]  AND
	...  elements.Дочекатися зникнення елемента зі сторінки  //button[text()="Я ознайомлений"]  2