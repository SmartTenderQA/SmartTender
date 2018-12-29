*** Keywords ***
Перейти у розділ (webclient)
    [Arguments]  ${name}
    Click Element  xpath=(//*[@title="${name}"])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Очистити фільтр "Умова відбору"
    Run Keyword And Ignore Error  Закрити валідаційне вікно  Умова відбору тендерів  OK


Змінити групу
	[Arguments]  ${text}
	Click Element  //*[contains(@title, 'Змінити групу: ')]
	Wait Until Page Contains Element  //*[@class="dx-vam" and text()="${text}"]
	Click Element  //*[@class="dx-vam" and text()="${text}"]