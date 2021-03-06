*** Keywords ***
Перейти у розділ (webclient)
    [Arguments]  ${name}
    Click Element  xpath=(//*[@title="${name}"])[1]
    Дочекатись закінчення загрузки сторінки
    Очистити фільтр "Умова відбору"
    Run Keyword And Ignore Error  Закрити валідаційне вікно  Умова відбору тендерів  OK


Змінити групу
	[Arguments]  ${text}
	Click Element  //*[contains(@title, 'Змінити групу: ')]
	Дочекатися відображення елемента на сторінці  //*[@class="dx-vam" and text()="${text}"]  5
	Click Element  //*[@class="dx-vam" and text()="${text}"]


Змінити мову (webclient)
    [Arguments]  ${lang}
    Click Element  //*[@data-name="MAINMENU__CHANGELANG"]
    Дочекатись закінчення загрузки сторінки
    elements.Дочекатися відображення елемента на сторінці  //span[text()="${lang}"]
    Click Element  //span[text()="${lang}"]
    Дочекатись закінчення загрузки сторінки
