REM https://github.com/zyxrhythm/zyx-tools/tree/master/win/hv.cmd
REM simple batch script to disable hyper-v on windows so VMware, VirtualBox and Hyper-V can coexist
@echo off
cls

REM store command result on a variable: https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
FOR /F "tokens=* USEBACKQ" %%F IN (`"bcdedit /enum | findstr hypervisorlaunchtype"`) DO ( SET hvstat=%%F )

REM new line in batch: https://stackoverflow.com/questions/132799/how-can-i-echo-a-newline-in-a-batch-file
ECHO.&echo Status: %hvstat%&echo.&echo.Options:&echo.

ECHO 1 = 'hypervisorlaunchtype ON' and reboot.&echo.&echo.    Enables hyper-v  and reboots the computer&echo.    Preventing VMware and VirtualBox to run.&echo.
 
ECHO 2 = 'hypervisorlaunchtype OFF' and reboot.&echo.&echo.    Disables hyper-v  and reboots the computer&echo.    Allowing VMware and VirtualBox to run.&echo.

ECHO "     hyper-v on and off ref: https://docs.microsoft.com/en-us/archive/blogs/gmarchetti/turning-hyper-v-on-and-off&echo."

ECHO 0 = Exit&echo.

SET /p option=What would you like to do? 

REM NOTE: the script will reboot the computer within 3 seconds
IF %option%==1 bcdedit /set hypervisorlaunchtype on & shutdown /r /t 3
IF %option%==2 bcdedit /set hypervisorlaunchtype off & shutdown /r /t 3
IF %option%==0 exit

PAUSE
