# Sample Conversion (`get-bdd`)

## Example Input

> When the user receives the setup file and double-clicks it, the installer opens on the Get Ready page. While the installer checks system requirements, a loader is shown and the Get Started button is disabled. If all checks pass, Get Started becomes enabled. If checks fail due to system limitations, show the Requirement Check page. When the user clicks Get Started, open the Installation page and start setup. If Ollama, the required model, Docker, and the EB container are already installed on the system, show the Finish page.

## Expected CSV Output

```csv
Sr.No.,Behavior Id,Given,Distilled Given,CRUD,When,Distilled When,Then
1,EB-OFFLINE-01,SETUP FILE RECEIVED,NONE,C,User opens the setup file.,DOUBLE_CLICK: Setup file,OPEN: Installer --> Get Ready page
2,EB-OFFLINE-02,UI - Get Ready Page,EB-OFFLINE-01,R,Installer checks the system requirements.,CHECK: System requirements,"SCREEN: Loader
BUTTON: Get Start Disabled"
3,EB-OFFLINE-03,UI - Get Ready Page,EB-OFFLINE-02,R,All system requirement checks pass.,SYSTEM: All checks pass,BUTTON: Get Start Enabled
4,EB-OFFLINE-04,UI - Get Ready Page,EB-OFFLINE-02,R,Requirements check fails due to system limitations.,SYSTEM: Requirements check failed,SCREEN: Requirement Check Page
5,EB-OFFLINE-05,UI - Get Ready Page,EB-OFFLINE-03,C,User clicks Get Started button.,BUTTON: Click Get Started,"SCREEN: Installation Page
STATE: Setup starts"
6,EB-OFFLINE-06,UI - Get Ready Page,EB-OFFLINE-05,R,"Ollama, required model, Docker, and EB container are already installed on the system.",CHECK: Pre-installed dependencies,SCREEN: Finish Page
```
