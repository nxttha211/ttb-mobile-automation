*** Settings ***
Library          AppiumLibrary
Resource         ../configs/android_config.robot
Resource         ../locator/main_page.robot

*** Keywords ***
Tap Add Todo Button
    Wait Until Element Is Visible    ${BTN_ADD_TODO}    ${TIMEOUT}
    Click Element    ${BTN_ADD_TODO}

Tap Navigate Back
    Press Keycode    4

Todo Item Should Be Visible
    [Arguments]    ${todo_title}
    Wait Until Page Contains    ${todo_title}    ${TIMEOUT}

Todo Item Should Not Be Visible
    [Arguments]    ${todo_text}
    Wait Until Page Does Not Contain    ${todo_text}    ${TIMEOUT}

Tap Todo Item
    [Arguments]    ${todo_text}
    Wait Until Page Contains    ${todo_text}    ${TIMEOUT}
    Click Element    xpath=//android.widget.TextView[@text="${todo_text}"]

Swipe To Delete Todo
    [Arguments]    ${todo_text}
    Wait Until Page Contains    ${todo_text}    ${TIMEOUT}
    ${element}=    Get Webelement    xpath=//android.widget.TextView[@text="${todo_text}"]
    ${location}=    Get Element Location    ${element}
    ${size}=    Get Element Size    ${element}
    ${start_x}=    Evaluate    int(${location['x']} + ${size['width']} - 20)
    ${end_x}=    Evaluate    int(${location['x']} + 20)
    ${y}=    Evaluate    int(${location['y']} + ${size['height']} / 2)
    Swipe    start_x=${start_x}    start_y=${y}    end_x=${end_x}    end_y=${y}

Empty View Should Be Visible
    Wait Until Element Is Visible    ${IMG_EMPTY}    ${TIMEOUT}
