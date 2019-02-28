*** Settings ***


*** Variables ***
${loading}                          //div[@class='smt-load']
#${webClient loading}                //*[contains(@class, 'LoadingPanel')]
${webClient loading}                //*[contains(@class, "LoadingPanel")]
${circle loading}                   //*[@class='loading_container']//*[@class='sk-circle']
${skeleton loading}                 //*[contains(@class,'skeleton-wrapper')]
${sales spin}                       //*[@class='ivu-spin']
${docs spin}                        //div[contains(@style, "loading")]
${weclient start}                   //*[@class="spinner"]
${loading bar}                      //div[@class="ivu-loading-bar"]   # полоса вверху страницы http://joxi.ru/Dr8xjNeT47v7Dr
${blocker}                          //*[@id="adorner"]
${sale web loading}                 //*[contains(@class,'disabled-block')]

${loadings}                         ${loading}|${webClient loading}|${circle loading}|${skeleton loading}|${sales spin}|${docs spin}|${weclient start}|${loading bar}|${blocker}|${sale web loading}

*** Keywords ***
Дочекатись закінчення загрузки сторінки
	Sleep  1
	elements.Дочекатися зникнення елемента зі сторінки  ${loadings}  120
	Sleep  .5
	${is visible}  Run Keyword And Return Status  Element Should Be Visible  ${loadings}
	Run Keyword If  ${is visible}
	...  Дочекатись закінчення загрузки сторінки


Дочекатись закінчення загрузки сторінки по елементу
    [Arguments]  ${locator}
    ${status}  ${message}  Run Keyword And Ignore Error
    ...  Wait Until Element Is Visible
    ...  ${locator}
    ...  3
    Run Keyword If  "${status}" == "PASS"
    ...  Run Keyword And Ignore Error
    ...  Wait Until Element Is Not Visible
    ...  ${locator}
    ...  120
