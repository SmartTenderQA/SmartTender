*** Variables ***
${contract_page}  //*[@id="modalContract"]//*[@class="ivu-modal-mask" and not(@style="display: none;")]/following-sibling::*


*** Keywords ***
Перевірити заголовок договору
	Wait Until Keyword Succeeds  20  1  Element Should Contain  ${contract_page}//*[contains(@class, "header")]  Договір


Перевірити перший абзац договору
	Element Should Contain  ${contract_page}//span
	...  Для участі у будь-якому статусі в електронних торгах (закупівлях) Вам необхідно укласти відповідний договір із Оператором електронного майданчика Smarttender.biz. Для цього Ви може скористатися Акцептом оферти (прийняття умов договору приєднання).


Перевірити лінки в тексті договору
	${should link1}  Set Variable  https://smarttender.biz/instruktsii/dogovir-pryednannya-so-2015-003-pro-nadannya-informatsiynyh-poslug-pid-chas-provedennya-protsedur-publichnyh-zakupivel-prozorro-ta-zakupivel-rialto/
	${should link2}  Set Variable  https://smarttender.biz/instruktsii/dogovir-pryednannya-so-2016-001-pro-nadannya-poslug-z-organizatsii-ta-provedennya-vidkrytyh-elektronnyh-torgiv-auktsioniv/
	${is link1}  Get Element Attribute  (${contract_page}//a[@href])[1]  href
	${is link1}  Поправити лінку для IP  ${is link1}
	${is link2}  Get Element Attribute  (${contract_page}//a[@href])[2]  href
	${is link2}  Поправити лінку для IP  ${is link2}
	Should Be Equal  ${is link1}  ${should link1}
	Should Be Equal  ${is link2}  ${should link2}