*** Keywords ***
Видалити кнопку "Поставити запитання"
	Wait Until Element Is Visible  //div[contains(@class, "widget-button-i24523139185")]
	Execute JavaScript  document.querySelector("div[class*=widget-button-i24523139185]").remove()


Видалити кнопку "Замовити звонок"
    Wait Until Page Contains Element  //*[@id="callback-btn"]
	Execute JavaScript  document.getElementById("callback-btn").outerHTML = ""