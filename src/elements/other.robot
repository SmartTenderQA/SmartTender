*** Keywords ***
Видалити кнопку "Поставити запитання"
	Wait Until Element Is Visible  //div[contains(@class, "widget-button-i24523139185")]
	Execute JavaScript  document.querySelector("div[class*=widget-button-i24523139185]").remove()


Видалити кнопку "Замовити звонок"
	Execute JavaScript  document.getElementById("callback-btn").outerHTML = ""