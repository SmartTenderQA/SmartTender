*** Keywords ***
Перевірка гарантійного внеску для мультилоту
	${status}  Перевірити необхідність наявності кнопки гарантійного внеску для мультилоту
	${location}  Get Location
	Run Keyword If  "${status}" == "True"  Run Keywords
	...  Open Button  ${first lot}
	...  AND  Select Frame  css=iframe
	...  AND  Відкрити сторінку гарантійного внеску
	...  AND  Go To  ${location}


Перевірити необхідність наявності кнопки гарантійного внеску для мультилоту
	${status}  Run Keyword And Return Status  Get From Dictionary  ${data['data']['lots'][0]}  guarantee
	${value}  Run Keyword If  "${status}" == "True"  Get From Dictionary  ${data['data']['lots'][0]['guarantee']}  amount
	${ret}  Run Keyword If  "${status}" == "True" and "${value}" != "0.0"  Set Variable  True  ELSE  Set Variable  False
	[Return]  ${ret}


Перевірка гарантійного внеску для не мультилоту
	${status}  Перевірити необхідність наявності кнопки гарантійного внеску
	Run Keyword If  "${status}" == "True"  Run Keywords
	...  Відкрити сторінку гарантійного внеску
	...  AND  Go Back


Перевірити необхідність наявності кнопки гарантійного внеску
	${status}  Run Keyword And Return Status  Get From Dictionary  ${data['data']}  guarantee
	${value}  Run Keyword If  "${status}" == "True"  Get From Dictionary  ${data['data']['guarantee']}  amount
	${ret}  Run Keyword If  "${status}" == "True" and "${value}" != "0.0"  Set Variable  True  ELSE  Set Variable  False
	[Return]  ${ret}


Відкрити сторінку гарантійного внеску
  Open Button  //*[@id="guarantee"]//a
  Run Keyword If  "${role}" != "viewer"  Run Keywords
  ...       Element Should Be Visible  //h4[contains(text(), "Оформлення заявки на тендерне забезпечення")]
  ...  AND  Location Should Contain  /GuaranteePage/
  ...  ELSE  Run Keywords
  ...       Location Should Contain  .biz/Errors/
  ...  AND  Element Should Contain  //h1/following-sibling::h2  Для просмотра страницы необходимо войти на сайт!