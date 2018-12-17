*** Keywords ***
Заповнити поля Рамкової угоди
    Натиснути кнопку "Коригувати рамкову угоду"
    ${id}  random number  100000  999999
    Заповнити текстове поле  (//*[@data-type="TextBox"])[1]//input  ${id}
    ${signDate}  get_time_now_with_deviation  0  days
    Заповнити текстове поле  (//*[@data-type="DateEdit"])[1]//input  ${signDate}
    ${startDate}  get_time_now_with_deviation  2  days
    Заповнити текстове поле  (//*[@data-type="DateEdit"])[2]//input  ${startDate}
    ${endDate}  get_time_now_with_deviation  60  days
    Заповнити текстове поле  (//*[@data-type="DateEdit"])[3]//input  ${endDate}
    Натиснути OkButton


Підтвердити активацію рамкової угоди
    ${status}  Run Keyword And Return Status
    ...  Wait Until Page Contains  Рамкову угоду успішно активовано  10
    Run Keyword If  ${status}  Click Element  //*[@id="IMMessageBoxBtnOK"]//span[text()="ОК"]
    Дочекатись закінчення загрузки сторінки(webclient)


