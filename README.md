# TTB Mobile Automation

Robot Framework + AppiumLibrary สำหรับ Android automation testing

## Setup
```bash
pip install -r requirements.txt
```

## Run Tests
```bash
robot --outputdir results tests/
```

## Project Structure
```
configs/    → Appium capabilities & settings
pages/      → Page Objects (locators + keywords)
tests/      → Test cases
resources/  → Shared keywords
results/    → HTML report output
```
