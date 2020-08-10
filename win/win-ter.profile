// This file was initially generated by Windows Terminal Preview 1.2.2022.0
// It should still be usable in newer versions, but newer versions might have additional
// settings, help text, or changes that you will not see unless you clear this file
// and let us generate a new one for you.

// To view the default settings, hold "alt" while clicking on the "Settings" button.
// For documentation on these settings, see: https://aka.ms/terminal-documentation
{
    "$schema": "https://aka.ms/terminal-profiles-schema",

    "defaultProfile": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",

    // You can add more global application settings here.
    // To learn more about global settings, visit https://aka.ms/terminal-global-settings

    // If enabled, selections are automatically copied to your clipboard.
    "copyOnSelect": false,

    // If enabled, formatted data is also copied to your clipboard
    "copyFormatting": false,

    // A profile specifies a command to execute paired with information about how it should look and feel.
    // Each one of them will appear in the 'New Tab' dropdown,
    //   and can be invoked from the commandline with `wt.exe -p xxx`
    // To learn more about profiles, visit https://aka.ms/terminal-profile-settings
    "profiles":
    {
        "defaults":
        {
            // Put settings here that you want to apply to all profiles.
			//"colorScheme": "Vintage",
			"copyOnSelect": "true",
			"tabWidthMode": "titleLength",
			"useAcrylic": true,
			"foreground": "#00E500",
			"background": "#000000",
			"backgroundImage": "C:/Users/zyxrh/Desktop/ZYX/WT/Wallpapers/obito.gif",
			"backgroundImageOpacity" : 0.03,
			"backgroundImageStrechMode" : "fill",
			"fontSize": 10,
			"acrylicOpacity": 0.8
			
        },
        "list":
        [
		    {
                // Make changes here to the cmd.exe profile.
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "name": "CMD",
                "commandline": "cmd.exe",
				"backgroundImage": "C:/Users/zyxrh/Desktop/ZYX/WT/Wallpapers/madara.gif",
				"startingDirectory" : "C:/Users/zyxrh/Desktop/LAB",
                "hidden": false
            },
            {
                // Make changes here to the powershell.exe profile.
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "name": "PowerShell",
                "commandline": "powershell.exe",
				"startingDirectory" : "C:/Users/zyxrh/Desktop/LAB",
                "hidden": false
            },
            {
                "guid": "{58ad8b0c-3ef8-5f4d-bc6f-13e4c00f2530}",
                "hidden": false,
                "name": "Debian",
                "source": "Windows.Terminal.Wsl"
            },
			{
                // Make changes here to the PYTHON profile.
                "guid": "{1850e97f-16dc-4281-9ea9-0100c4e852c5}",
                "name": "Python",
                "commandline": "python.exe",
				"icon" : "C:/Users/zyxrh/Desktop/ZYX/WT/Icons/python.png",
                "hidden": false
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": true,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            }
        ]
    },

    // Add custom color schemes to this array.
    // To learn more about color schemes, visit https://aka.ms/terminal-color-schemes
    "schemes": [],

    // Add custom keybindings to this array.
    // To unbind a key combination from your defaults.json, set the command to "unbound".
    // To learn more about keybindings, visit https://aka.ms/terminal-keybindings
    "keybindings":
    [
        // Copy and paste are bound to Ctrl+Shift+C and Ctrl+Shift+V in your defaults.json.
        // These two lines additionally bind them to Ctrl+C and Ctrl+V.
        // To learn more about selection, visit https://aka.ms/terminal-selection
        { "command": {"action": "copy", "singleLine": false }, "keys": "ctrl+c" },
        { "command": "paste", "keys": "ctrl+v" },

        // Press Ctrl+Shift+F to open the search box
        { "command": "find", "keys": "ctrl+f" },
		
        // Press Ctrl+Shift+F to open the search box
        { "command": "closeTab", "keys": "ctrl+w" },

        // Press Alt+Shift+D to open a new pane.
        // - "split": "auto" makes this pane open in the direction that provides the most surface area.
        // - "splitMode": "duplicate" makes the new pane use the focused pane's profile.
        // To learn more about panes, visit https://aka.ms/terminal-panes
        { "command": { "action": "splitPane", "split": "auto", "splitMode": "duplicate" }, "keys": "alt+shift+d" }
    ]
}
