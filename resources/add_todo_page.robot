*** Settings ***
Library          AppiumLibrary
Resource         ../configs/android_config.robot
Resource         ../locator/add_todo_page.robot

*** Keywords ***
# ========== Basic Actions ==========

Input Todo Title
    [Arguments]    ${title}
    Wait Until Element Is Visible    ${NAME_TITLE}    ${TIMEOUT}
    Input Text    ${NAME_TITLE}    ${title}

Tap Save Button
    Wait Until Element Is Visible    ${BTN_SAVE}    ${TIMEOUT}
    Click Element    ${BTN_SAVE}

Create New Todo
    [Arguments]    ${title}
    Input Todo Title    ${title}
    Tap Save Button

# ========== Reminder ==========

Enable Reminder
    Wait Until Element Is Visible    ${REMIND_TOGGLE}    ${TIMEOUT}
    ${status}=    Get Element Attribute    ${REMIND_TOGGLE}    checked
    IF    '${status}' == 'false'
        Click Element    ${REMIND_TOGGLE}
        Wait Until Element Is Visible    ${TXT_DATE}    ${TIMEOUT}
    END

Disable Reminder
    Wait Until Element Is Visible    ${REMIND_TOGGLE}    ${TIMEOUT}
    ${status}=    Get Element Attribute    ${REMIND_TOGGLE}    checked
    IF    '${status}' == 'true'
        Click Element    ${REMIND_TOGGLE}
    END

Reminder Section Should Not Be Visible
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${LBL_DATE_TIME}    3
    Should Be Equal    ${visible}    ${FALSE}

Reminder Text Should Contain
    [Arguments]    ${expected_text}
    Wait Until Element Is Visible    ${LBL_REMINDER_TEXT}    ${TIMEOUT}
    ${text}=    Get Text    ${LBL_REMINDER_TEXT}
    Should Contain    ${text}    ${expected_text}

# ========== Date Picker ==========

Select Date
    [Arguments]    ${day}    ${month}    ${year}
    Wait Until Element Is Visible    ${TXT_DATE}    ${TIMEOUT}
    Click Element    ${TXT_DATE}
    Wait Until Element Is Visible    ${BTN_PICKER_OK}    ${TIMEOUT}
    Navigate To Month    ${month}    ${year}
    Click Element    xpath=//android.view.View[contains(@content-desc, "${day} ${month} ${year}")]
    Click Element    ${BTN_PICKER_OK}
    Wait Until Element Is Visible    ${TXT_DATE}    ${TIMEOUT}

Navigate To Month
    [Arguments]    ${month}    ${year}
    FOR    ${i}    IN RANGE    36
        ${found}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    xpath=//android.view.View[contains(@content-desc, "${month} ${year}")]    2
        IF    ${found}    RETURN
        Execute Script    mobile: swipeGesture
        ...    left=${206}    top=${1119}    width=${667}    height=${662}
        ...    direction=right    percent=${0.75}
    END

Select Past Date In Current Month
    [Documentation]    Select yesterday in date picker. If today is 1st, swipe to previous month.
    Wait Until Element Is Visible    ${TXT_DATE}    ${TIMEOUT}
    Click Element    ${TXT_DATE}
    Wait Until Element Is Visible    ${BTN_PICKER_OK}    ${TIMEOUT}
    ${today}=    Evaluate    datetime.datetime.now().day    modules=datetime
    ${yesterday}=    Evaluate    (datetime.datetime.now() - datetime.timedelta(days=1)).strftime("%d %B %Y")    modules=datetime
    IF    ${today} == 1
        Execute Script    mobile: swipeGesture
        ...    left=${206}    top=${1119}    width=${667}    height=${662}
        ...    direction=right    percent=${0.75}
        Wait Until Element Is Visible    xpath=//android.view.View[contains(@content-desc, "${yesterday}")]    5
    END
    Click Element    xpath=//android.view.View[contains(@content-desc, "${yesterday}")]
    Click Element    ${BTN_PICKER_OK}
    Wait Until Element Is Visible    ${REMIND_TOGGLE}    ${TIMEOUT}

Date Field Should Show Today
    Wait Until Element Is Visible    ${TXT_DATE}    ${TIMEOUT}
    ${date_text}=    Get Text    ${TXT_DATE}
    Should Be Equal    ${date_text}    Today

# ========== Time Picker ==========

Select Time
    [Arguments]    ${hour}    ${minute}    ${ampm}
    Wait Until Element Is Visible    ${TXT_TIME}    ${TIMEOUT}
    Click Element    ${TXT_TIME}
    Wait Until Element Is Visible    ${BTN_HOURS}    ${TIMEOUT}
    Click Element    ${BTN_HOURS}
    Tap Clock Position    ${hour}    12
    Verify Hour Selected    ${hour}
    Click Element    ${BTN_MINUTES}
    Tap Clock Position    ${minute}    60
    Set AmPm    ${ampm}
    Click Element    ${BTN_PICKER_OK}
    Wait Until Element Is Visible    ${TXT_TIME}    ${TIMEOUT}

Tap Clock Position
    [Documentation]    Tap position on circular clock. divisions=12 for hours, 60 for minutes.
    [Arguments]    ${value}    ${divisions}
    ${loc}=    Get Element Location    ${CLOCK_FACE}
    ${size}=    Get Element Size    ${CLOCK_FACE}
    ${cx}=    Evaluate    int(${loc['x']} + ${size['width']} / 2)
    ${cy}=    Evaluate    int(${loc['y']} + ${size['height']} / 2)
    ${r}=    Evaluate    int(min(${size['width']}, ${size['height']}) / 2 * 0.65)
    ${v}=    Convert To Integer    ${value}
    ${d}=    Convert To Integer    ${divisions}
    ${angle}=    Evaluate    (${v} % ${d}) * (360 / ${d}) - 90
    ${rad}=    Evaluate    ${angle} * 3.14159265 / 180
    ${tx}=    Evaluate    int(${cx} + ${r} * __import__('math').cos(${rad}))
    ${ty}=    Evaluate    int(${cy} + ${r} * __import__('math').sin(${rad}))
    @{pos}=    Create List    ${tx}    ${ty}
    @{positions}=    Create List    ${pos}
    Tap With Positions    500ms    @{positions}

Verify Hour Selected
    [Arguments]    ${expected_hour}
    FOR    ${retry}    IN RANGE    3
        ${actual}=    Get Text    ${BTN_HOURS}
        ${match}=    Evaluate    str(int('${actual}')) == str(int('${expected_hour}'))
        IF    ${match}    RETURN
        Tap Clock Position    ${expected_hour}    12
    END
    Should Be Equal As Integers    ${actual}    ${expected_hour}

Set AmPm
    [Arguments]    ${expected_ampm}
    ${current}=    Get Text    ${LBL_AMPM}
    IF    '${current}' != '${expected_ampm}'
        Click Element    ${BTN_AMPM}
    END
