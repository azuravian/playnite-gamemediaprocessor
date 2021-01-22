function global:GetMainMenuItems
{
    param($menuArgs)

    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.Description = "Resize Images"
    $menuItem.FunctionName = "OpenMenu"

    return $menuItem
}

function OpenMenu
{
    # Load assemblies
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName PresentationFramework
    
    # Set Xaml
    [xml]$Xaml = @"
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation">
    <Grid.Resources>
        <Style TargetType="TextBlock" BasedOn="{StaticResource BaseTextBlockStyle}" />
    </Grid.Resources>
    <Border Margin="40,50,273.6,0" VerticalAlignment="Top" Height="25" Width="180" HorizontalAlignment="Left">
        <TextBlock TextWrapping="Wrap" Text="Game Selection" VerticalAlignment="Center" Width="180"/>
    </Border>
    <ComboBox Name="CbGameSelection" SelectedIndex="0" HorizontalAlignment="Left" Margin="245,50,0,0" VerticalAlignment="Top" Height="25" Width="200">
        <ComboBoxItem Content="All games in database" HorizontalAlignment="Stretch"/>
        <ComboBoxItem Content="Selected Games" HorizontalAlignment="Stretch"/>
    </ComboBox>
    <Border Margin="40,90,273.6,0" VerticalAlignment="Top" Width="180" Height="25" HorizontalAlignment="Left">
        <TextBlock TextWrapping="Wrap" Text="Media type selection" VerticalAlignment="Center" Margin="0,4,-0.6,4.8" Width="180"/>
    </Border>
    <ComboBox Name="CbMediaType" SelectedIndex="0" HorizontalAlignment="Left" Margin="245,90,0,0" VerticalAlignment="Top" Width="200" Height="25">
        <ComboBoxItem Content="Cover Image" HorizontalAlignment="Stretch"/>
        <ComboBoxItem Content="Background Image" HorizontalAlignment="Stretch"/>
        <ComboBoxItem Content="Icon" HorizontalAlignment="Stretch"/>
    </ComboBox>
	<TabControl Name="ControlTools" HorizontalAlignment="Left" Height="185" Margin="40,143,34.6,44" VerticalAlignment="Top">
		<TabItem Header="Resolution">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will resize images of the selected type and games.  Set max width and height below.  Images will retain their current aspect ratio." VerticalAlignment="Top" Width="303"/>
				<TextBox Name="BoxResolutionWidth" HorizontalAlignment="Left" Height="25" Margin="77,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="50"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="260" Height="20"><Run Text="Enter "/><Run Text="resolution in pixels"/></TextBlock>
				<TextBox Name="BoxResolutionHeight" HorizontalAlignment="Left" Height="25" Margin="197,119,0,-11.8" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="50"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Width"/>
				<TextBlock HorizontalAlignment="Left" Margin="137,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Height"/>
			</Grid>
		</TabItem>
	</TabControl>
    <Button Content="Update Tags" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="224,357,0,0" Name="ButtonUpdateTags" IsDefault="True"/>
</Grid>
"@

    # Load the xaml for controls
    $XMLReader = [System.Xml.XmlNodeReader]::New($Xaml)
    $XMLForm = [Windows.Markup.XamlReader]::Load($XMLReader)

    # Make variables for each control
    $Xaml.FirstChild.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name $_.Name -Value $XMLForm.FindName($_.Name) }

    # Set Window creation options
    $WindowCreationOptions = New-Object Playnite.SDK.WindowCreationOptions
    $WindowCreationOptions.ShowCloseButton = $true
    $WindowCreationOptions.ShowMaximizeButton = $False
    $WindowCreationOptions.ShowMinimizeButton = $False

    # Create window
    $Window = $PlayniteApi.Dialogs.CreateWindow($WindowCreationOptions)
    $Window.Content = $XMLForm
    $Window.Width = 620
    $Window.Height = 460
    $Window.Title = "Resize Images"
    $Window.WindowStartupLocation = "CenterScreen"

    # Handler for pressing "Add Tags" button
    $ButtonUpdateTags.Add_Click(
    {
        # Get the variables from the controls
        $GameSelection = $CbGameSelection.SelectedIndex
        $MediaTypeSelection = $CbMediaType.SelectedIndex

        # Set GameDatabase
        switch ($GameSelection) {
            0 {
                $GameDatabase = $PlayniteApi.Database.Games
                $__logger.Info("Resize Images - Game Selection: `"AllGames`"")
            }
            1 {
                $GameDatabase = $PlayniteApi.MainView.SelectedGames
                $__logger.Info("Resize Images - Game Selection: `"SelectedGames`"")
            }
        }

        # Set Media Type
        switch ($MediaTypeSelection) {
            0 { 
                $MediaType = "Cover"
                $OptimizedSize = 1
                $__logger.Info("Resize Images - Media Selection: `"$MediaType`"")
            }
            1 {
                $MediaType = "Background"
                $OptimizedSize = 4
                $__logger.Info("Resize Images - Media Selection: `"$MediaType`"")
            }
            2 {
                $MediaType = "Icon"
                $OptimizedSize = 0.1
                $__logger.Info("Resize Images - Media Selection: `"$MediaType`"")
            }
        }

        # Set Parameters
        $Width = $BoxResolutionWidth.Text
        $Height = $BoxResolutionHeight.Text

		if ( ($Width -match "^\d+$") -and ($Height -match "^\d+$") )
		{
			# Set tag Name
			$TagTitle = "Resolution"
			$TagDescription = "Resized to $Width`x$height"
			$TagName = "$TagTitle`: $MediaType`(s) $TagDescription"
			
			# Set function to determine tag operation
			$ToolFunctionName = "ToolImageResolution"
			$AdditionalOperation = "GetDimensions"
			$ExtraParameters = @(
				$Width,
				$Height
			)

			# Start Resize Images function
			$__logger.Info("Resize Images - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation, $ExtraParameters`"")
			Invoke-ResizeImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation $ExtraParameters
		}
		else
		{
			$__logger.Info("Resize Images - Invalid Input `"$Width`", `"$Height`"")
			$PlayniteApi.Dialogs.ShowMessage("Invalid Input in Width and height Input boxes.", "Resize Images");
		}
    })

    # Show Window
    $__logger.Info("Resize Images - Opening Window.")
    $Window.ShowDialog()
    $__logger.Info("Resize Images - Window closed.")
}

function Invoke-ResizeImages
{
    param (
        $GameDatabase, 
        $MediaType,
        $TagName,
        $ToolFunctionName,
        $AdditionalOperation,
        $ExtraParameters
    )
    
	# Try to get magick.exe path via registry
    $Key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
    $RegSubKey =  $Key.OpenSubKey("Software\ImageMagick\Current")
    if ($RegSubKey)
    {
        $RegInstallDir = $RegSubKey.GetValue("BinPath")
        if ($RegInstallDir)
        {
            $MagickExecutable = Join-Path -Path $RegInstallDir -ChildPath 'magick.exe'
            if (Test-Path $MagickExecutable)
            {
                $MagickExecutablePath = $MagickExecutable
                $__logger.Info("Resize Images - Found executable Path via registry in `"$MagickExecutablePath`".")
            }
        }
    }

    if ($null -eq $MagickExecutablePath)
    {
        # Set Magick Executable Path via user Input
        $MagickConfigPath = Join-Path -Path $CurrentExtensionDataPath -ChildPath 'ConfigMagicPath.ini'
        if (Test-Path $MagickConfigPath)
        {
            $MagickExecutablePath = [System.IO.File]::ReadAllLines($MagickConfigPath)
        }
        else
        {
            $PlayniteApi.Dialogs.ShowMessage("Select ImageMagick executable", "Resize Images")
            $MagickExecutablePath = $PlayniteApi.Dialogs.SelectFile("magick|magick.exe")
            if (!$MagickExecutablePath)
            {
                exit
            }
            [System.IO.File]::WriteAllLines($MagickConfigPath, $MagickExecutablePath)
            $__logger.Info("Resize Images - Saved executable Path via user input in `"$MagickExecutablePath`".")
            $PlayniteApi.Dialogs.ShowMessage("Magick executable path saved", "Resize Images")
        }

        if (!(Test-Path $MagickExecutablePath))
        {
            [System.IO.File]::Delete($MagickConfigPath)
            $__logger.Info("Resize Images - Executable not found in user configured path `"$MagickExecutablePath`".")
            $PlayniteApi.Dialogs.ShowMessage("Magick executable not found in `"$MagickExecutablePath`". Please run the extension again to configure it to the correct location.", "Resize Images")
            exit
        }
    }	
	
    # Create "No Media" tag
    $tagNoMediaName = "No Media: " + "$MediaType"
    $tagNoMedia = $PlayniteApi.Database.tags.Add($tagNoMediaName)
    $global:tagNoMediaIds = $tagNoMedia.Id

    # Create Tool tag
    if ($TagName)
    {
        $tagMatch = $PlayniteApi.Database.tags.Add($TagName)
        $global:ToolTagId = $tagMatch.Id
    }
    
    foreach ($Game in $GameDatabase) {
        # Get Image File path
        Get-ImagePath $game $MediaType

        # Verify if Image File path was obtained
        if ($ImageFilePath)
        {
            # Remove "No Media" tag
            Remove-TagFromGame $game $tagNoMediaIds

            # Skip Game if media is of URL type
            if ($ImageFilePath -match "https?:\/\/")
            {
                continue
            }
            
            # Skip game if file path doesn't exist and delete property value
            if ([System.IO.File]::Exists($ImageFilePath) -eq $false)
            {
                if ($MediaType -eq "Cover")
                {
                    $game.CoverImage = $null
                    
                }
                elseif ($MediaType -eq "Background")
                {
                    $game.BackgroundImage = $null
                }
                elseif ($MediaType -eq "Icon")
                {
                    $game.Icon = $null
                }
                $__logger.Info("Resize Images - `"$($game.name)`" $MediaType doesn't exist in pointed path. Property value deleted.")
                continue
            }

            # Determine Tag Operation
            if ($AdditionalOperation -eq "GetDimensions")
            {
                $global:ImageSuccess = $false
                Get-ImageDimensions $ImageFilePath

                # Skip if couldn't get image information
                if ($ImageSuccess -eq $false)
                {
                    continue
                }
                &$ToolFunctionName $ImageWidth $ImageHeight $ExtraParameters
            }
            else
            {
                continue
            }

            # Resize Images
            if ($Operation -eq "Resize")
            {
				
                & "$MagickExecutablePath" mogrify -quiet -resize $Width'x'$Height "$ImageFilePath"
            }
            else
            {
                continue
            }
        }
        else
        {
            # Add "No Media Tag"
            Add-TagToGame $game $tagNoMediaIds
        }
    }
    
    # Generate results of missing media in selection
    $GamesNoMediaSelection = $GameDatabase | Where-Object {$_.TagIds -contains $tagNoMediaIds.Guid}
    $Results = "Finished. Games in selection: $($GameDatabase.count)`n`nSelected Media: $MediaType`nGames missing selected media in selection: $($GamesNoMediaSelection.Count)"

    # Get information of games with missing media in all database and add to results
    $GamesNoCoverAll = ($PlayniteApi.Database.Games | Where-Object {$null -eq $_.CoverImage}).count
    $GamesNoBackgroundAll = ($PlayniteApi.Database.Games | Where-Object {$null -eq $_.BackgroundImage}).count
    $GamesNoIconAll = ($PlayniteApi.Database.Games | Where-Object {$null -eq $_.Icon}).count
    $Results += "`n`nMissing Media in all database`nCovers: $GamesNoCoverAll games`nBackground Images: $GamesNoBackgroundAll games`nIcons: $GamesNoIconAll games"

    # Get information of tool Tag
    if ($TagName)
    {
        $GamesToolTagSelection = $GameDatabase | Where-Object {$_.TagIds -contains $ToolTagId.Guid}
        $GamesToolTagAll = $PlayniteApi.Database.Games | Where-Object {$_.TagIds -contains $ToolTagId.Guid}
        $__logger.Info("Resize Images - Games with tool tag `"$TagName`" at finish: Selection $($GamesToolTagSelection.Count), All $($GamesToolTagAll.Count)")

        # Add information to results
        $Results += "`n`n$TagName"
        
        # Remove tool tag from database if 0 games have it
        if (($GamesToolTagAll.count -eq 0) -and ($GamesToolTagSelection.count -eq 0))
        {
            $PlayniteApi.Database.Tags.Remove($ToolTagId)
            $__logger.Info("Resize Images - Removed tool tag `"$TagName`" from database")
        }
    }

    # Show Results
    $__logger.Info("Resize Images - $($Results -replace "`n", ', ')")
    $PlayniteApi.Dialogs.ShowMessage("$Results", "Resize Images");
}

function Get-ImageDimensions
{
    param (
        $ImageFilePath
    )

    # Get image width and height
    try {
        Add-type -AssemblyName System.Drawing
        $Image = New-Object System.Drawing.Bitmap $ImageFilePath
        $global:ImageHeight = [int]$image.Height
        $global:imageWidth = [int]$image.Width
        $Image.Dispose()
        $global:ImageSuccess = $true
    } catch {
        $global:ImageSuccess = $false
        $ErrorMessage = $_.Exception.Message
        $__logger.Error("Resize Images - $($game.name): Error `"$ErrorMessage`" when processing image `"$ImageFilePath`"")
    }
}

function Get-ImagePath
{
    param (
        [object]$game, 
        [string]$MediaType
    )

    # Verify selected media type, if game has it and get full file path
    if ( ($MediaType -eq "Cover") -and ($game.CoverImage) )
    {
        $global:ImageFilePath = $PlayniteApi.Database.GetFullFilePath($game.CoverImage)
    }
    elseif ( ($MediaType -eq "Background") -and ($game.BackgroundImage) )
    {
        $global:ImageFilePath = $PlayniteApi.Database.GetFullFilePath($game.BackgroundImage)
    }
    elseif ( ($MediaType -eq "Icon") -and ($game.Icon) )
    {
        $global:ImageFilePath = $PlayniteApi.Database.GetFullFilePath($game.Icon)
    }
    else
    {
        $global:ImageFilePath = $null
    }
}

function Add-TagToGame
{
    param (
        $game,
        $tagIds
    )

    # Check if game already doesn't have tag
    if ($game.tagIds -notcontains $tagIds)
    {
        # Add tag Id to game
        if ($game.tagIds)
        {
            $game.tagIds += $tagIds
        }
        else
        {
            # Fix in case game has null tagIds
            $game.tagIds = $tagIds
        }
        
        # Update game in database and increase no media count
        $PlayniteApi.Database.Games.Update($game)
    }
}

function Remove-TagFromGame
{
    param (
        $game,
        $tagIds
    )

    # Check if game already has tag and remove it
    if ($game.tagIds -contains $tagIds)
    {
        $game.tagIds.Remove($tagIds)
        $PlayniteApi.Database.Games.Update($game)
    }
}

function ToolImageResolution
{
    param (
        $ImageWidth,
        $ImageHeight,
        $ExtraParameters
    )
    
    # Tool #3: Resolution
    # Get extra parameters
    $Width = [int]$ExtraParameters[0]
    $Height = [int]$ExtraParameters[1]

    if ( ($Width -lt $ImageWidth) -Or ($Height -lt $ImageHeight) )
    {
	    $global:Operation = "Resize"
    }
    else
    {
        continue
    }
}
