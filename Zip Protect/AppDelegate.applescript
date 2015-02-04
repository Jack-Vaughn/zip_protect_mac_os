--
--  AppDelegate.applescript
--  Zip Protect
--
--  Created by Vaughn, Jack on 1/21/15.
--  Copyright (c) 2015 RCSNC. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
	
	-- IBOutlets
	property theWindow : missing value
    property theZipButton : missing value
    property chooseButton : missing value
    property differentButton : missing value
    property compressionRadio : missing value
    property fileOrFolderRadio : missing value
    property passwordField : missing value
    property label : missing value
    property progressCircle : missing value
    property nameLabel : missing value
    property passwordLabel : missing value
    property nameField : missing value
    
    -- Global Variables
    
    global zipLocation
    
    global thePassword
    
    -- Functions
    
    on hide(itemName)
        
        itemName's setHidden_(true)
        
    end hide
    
    on show(itemName)
        
        itemName's setHidden_(false)
        
    end show
    
    on animate(itemName, trueOrFalse)
        
        if trueOrFalse is true then
            
            tell itemName to startAnimation:me
        
        else
        
        tell itemName to stopAnimation:me
        
        end if
        
    end animate
    
    on deleteCharactersFromEnd(theString, numberOfDeletions)
        
        set theString to (theString) as string
        
        set total to (count of characters of theString)
        
        return (characters 1 thru (total - numberOfDeletions) of text of theString) as text
        
    end deleteCharactersFromEnd
    
    on secureZip(location, thePassword, theName)
        
        set parentLocation to do shell script "dirname " & quote & location & quote
        
        set compressionRow to (compressionRadio's selectedRow()) as integer
        
        set baseName to do shell script "basename " & quote & location & quote
        
        if theName is "" then
            
            set fileName to do shell script "basename " & quote & location & quote
            
        else
        
            set fileName to theName
        
        end if
        
        try
            
            do shell script "rm -r " & quote & location & ".zip" & quote
            
        end try
        
        tell application "Terminal"
            quit
            delay 0.5
            activate
            delay 0.5
            set a to 0
            repeat until (a = 1)
                if (window 1 is not busy) then
                    set a to 1
                end if
            end repeat
            try
                tell application "System Events" to tell process "Terminal" to set visible to false
            end try
            do script "cd " & quote & parentLocation & quote in window 1
            if compressionRow is 0 then
            do script "zip -er " & quote & fileName & ".zip" & quote & " " & quote & baseName & quote in window 1
            else
            do script "zip -er0 " & quote & fileName & ".zip" & quote & " " & quote & baseName & quote in window 1
            end if
            delay 1
            do script thePassword in window 1
            log thePassword
            do script thePassword in window 1
            set a to 0
            repeat until (a = 1)
                if (window 1 is not busy) then
                    close window 1
                    set a to 1
                end if
            end repeat
            quit
        end tell
    
    end secureZip
    
    on zip(location, theName)
        
        set fileName to do shell script "basename " & quote & location & quote
        
        set parentLocation to do shell script "dirname " & quote & location & quote
        
        set compressionRow to (compressionRadio's selectedRow()) as integer
        
        set baseName to do shell script "basename " & quote & location & quote
        
        if theName is "" then
            
            set fileName to do shell script "basename " & quote & location & quote
            
            else
            
            set fileName to theName
            
        end if
        
        try
            
            do shell script "rm -r " & quote & location & ".zip" & quote
            
        end try
        
        tell application "Terminal"
            quit
            delay 0.5
            activate
            delay 0.5
            set a to 0
            repeat until (a = 1)
                if (window 1 is not busy) then
                    set a to 1
                end if
            end repeat
            try
                tell application "System Events" to tell process "Terminal" to set visible to false
            end try
            do script "cd " & quote & parentLocation & quote in window 1
            if compressionRow is 0 then
            do script "zip -r " & quote & fileName & ".zip" & quote & " " & quote & baseName & quote in window 1
            else
            do script "zip -r0 " & quote & fileName & ".zip" & quote & " " & quote & baseName & quote in window 1
            end if
            delay 1
            set a to 0
            repeat until (a = 1)
                if (window 1 is not busy) then
                    close window 1
                    set a to 1
                end if
            end repeat
            quit
        end tell
        
    end zip
    
    on resetUI()
        
        hide(progressCircle)
        
        animate(progressCircle, false)
        
        label's setStringValue_("Done!\nPlease Select Another Folder Or File To Password Protect")
        
        hide(differentButton)
        
        hide(theZipButton)
        
        hide(nameLabel)
        
        hide(nameField)
        
        hide(passwordLabel)
        
        hide(passwordField)
        
        show(chooseButton)
        
        set thePassword to ""
        
        display notification "The Zip Has Finished." with title "Zip Complete" sound name "Glass"
        
    end resetUI
    
    -- Button Functions
    
    on folderPressed_(sender)
        
        chooseButton's setTitle_("Choose Folder")
        
        differentButton's setTitle_("Choose Another Folder")
        
        log "Choose Folder"
        
    end folderPressed_
    
    on filePressed_(sender)
        
        chooseButton's setTitle_("Choose File")
        
        differentButton's setTitle_("Choose Another File")
        
        log "Choose File"
        
    end filePressed_
    
    on chooseFile_(sender)
        
        set fileOrFolderRow to (fileOrFolderRadio's selectedRow()) as integer
        
        if fileOrFolderRow is 0 --file
        
        set zipLocation to choose file with prompt "Please choose the file you wish to password zip."
        
        set zipLocation to POSIX path of zipLocation
        
        else --folder
        
        set zipLocation to choose folder with prompt "Please choose the folder you wish to password zip."
        
        set zipLocation to POSIX path of zipLocation
        
        set ziplocation to deleteCharactersFromEnd(zipLocation, 1)
        
        end if
    
    label's setStringValue_("Please Enter The Password You Would Like Below")
    
    show(theZipButton)
    
    show(passwordField)
    
    show(differentButton)
    
    hide(chooseButton)
    
    show(nameLabel)
    
    show(passwordLabel)
    
    show(nameField)
    
    end chooseFile_

    on zipButtonPressed_(sender)
        
        label's setStringValue_("Working...")
        
        show(progressCircle)
        
        animate(progressCircle, true)
        
        set thePassword to passwordField's stringValue() as text
        
        set theName to nameField's stringValue() as text
        
        passwordField's setStringValue_("")
        
        nameField's setStringValue_("")
        
        if thePassword is "" then
            
        zip(zipLocation, theName)
            
        else
        
        secureZip(zipLocation, thePassword, theName)
        
        end if
        
        resetUI()
        
    end zipButtonPressed_

    
    -- Default Functions
	
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
    end applicationShouldTerminate_
    
    on applicationShouldTerminateAfterLastWindowClosed_(sender) --this function closes the program when 'x' button is clicked
        return true
    end applicationShouldTerminateAfterLastWindowClosed_
	
end script