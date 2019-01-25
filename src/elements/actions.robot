*** Keywords ***
Створити словник
    [Arguments]  ${name}
    ${dict}  Create Dictionary
    Set Global Variable  ${${name}}  ${dict}


Зберегти словник у файл
    [Arguments]  ${dict}  ${filename}
	${json}  conver dict to json  ${dict}
	Create File  ${OUTPUTDIR}/artifact_${filename}.json  ${json}


Додати doc файл
	[Arguments]  ${block}=1
	${doc}=  create_fake_doc
	${md5}  get_checksum_md5  ${OUTPUTDIR}/${doc[1]}
	${path}  Set Variable  ${doc[0]}
	Choose File  xpath=(//input[@type="file"][1])[${block}]  ${path}
	[Return]  ${doc[1]}  ${md5}