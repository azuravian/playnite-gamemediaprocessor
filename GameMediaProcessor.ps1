function global:GetMainMenuItems
{
    param($menuArgs)

    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.FunctionName = "OpenMenu"
    $menuItem.Description = "Open Media Processor"
	$menuItem.MenuSection = "@Game Media Tools"

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
    <CheckBox Name="cbnobackup" IsChecked="False" Content="Don't Backup Images" Margin="245,15,0,0" VerticalAlignment="Top"/>
	<ComboBox Name="CbGameSelection" SelectedIndex="1" HorizontalAlignment="Left" Margin="245,50,0,0" VerticalAlignment="Top" Height="25" Width="200">
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
		<ComboBoxItem Content="Logo" HorizontalAlignment="Stretch"/>
    </ComboBox>
	
	<TabControl Name="ControlTools" HorizontalAlignment="Left" Height="205" Margin="40,143,34.6,44" VerticalAlignment="Top">
		<TabItem Header="Resize">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will resize images of the selected type and games.  Set max width and height below.  Images will retain their current aspect ratio." VerticalAlignment="Top" Width="500"/>
				<TextBox Name="BoxResizeWidth" HorizontalAlignment="Left" Height="25" Margin="77,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="50"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="260" Height="20"><Run Text="Enter "/><Run Text="resolution in pixels"/></TextBlock>
				<TextBox Name="BoxResizeHeight" HorizontalAlignment="Left" Height="25" Margin="197,119,0,-11.8" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="50"/>
				<CheckBox Name="cbkeepaspect" IsChecked="True" Content="Keep Aspect Ratio" Margin = "257,112,0,-11.8" VerticalAlignment="Top" Height="20"/>
				<CheckBox Name="cbresizeshrink" IsChecked="True" Content="Only Shrink" Margin = "257,137,0,-11.8" VerticalAlignment="Top" Height="20"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Width"/>
				<TextBlock HorizontalAlignment="Left" Margin="137,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Height"/>
			</Grid>
		</TabItem>
		<TabItem Header="Resize and Crop">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will resize images of the selected type and games.  Set width and height below.  Images will be cropped to meet the input aspect ratio." VerticalAlignment="Top" Width="500"/>
				<TextBox Name="BoxCropWidth" HorizontalAlignment="Left" Height="25" Margin="77,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="50"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,90,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="260" Height="20"><Run Text="Enter "/><Run Text="resolution in pixels"/></TextBlock>
				<TextBox Name="BoxCropHeight" HorizontalAlignment="Left" Height="25" Margin="197,119,0,-11.8" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="50"/>
				<TextBox Name="BoxCropGravity" HorizontalAlignment="Left" Height="25" Margin="317,119,0,-11.8" TextWrapping="Wrap" Text="Center" VerticalAlignment="Top" Width="80"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Width"/>
				<TextBlock HorizontalAlignment="Left" Margin="137,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Height"/>
				<TextBlock HorizontalAlignment="Left" Margin="257,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Gravity"/>
				<CheckBox Name="cbcropshrink" IsChecked="True" Content="Only Shrink" Margin = "287,152,0,-11.8" VerticalAlignment="Top" Height="20"/>
			</Grid>
		</TabItem>
		<TabItem Header="Trim">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will trim the borders of an image.  For example, if an image has a colored (or transparent) border, this will remove the border from each edge." VerticalAlignment="Top" Width="500"/>
				<CheckBox Name="cbtrimtrans" IsChecked="True" Content="Only Transparent" Margin = "257,92,0,-11.8" VerticalAlignment="Top" Height="20"/>
			</Grid>
		</TabItem>
		<TabItem Header="Flip">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will Flip the image along the horizontal access.  It will save the original images so you can revert later if necessary." VerticalAlignment="Top" Width="500"/>
			</Grid>
		</TabItem>
		<TabItem Header="Fade">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will fade the edges of images of the selected type and games.  Set the level of fade in pixels below.  This must be a whole number greater than 0.  It will save the original images so you can revert later if necessary." VerticalAlignment="Top" Width="500"/>
				<TextBox Name="BoxFadeEdges" HorizontalAlignment="Left" Height="25" Margin="97,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="50"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="80" Height="20" Text="Fade Level"/>
			</Grid>
		</TabItem>
		<TabItem Header="Grayscale">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will convert selected images to grayscale.  It will save the color images so you can revert later if necessary." VerticalAlignment="Top" Width="500"/>
			</Grid>
		</TabItem>
		<TabItem Header="Colorshift">
			<Grid>
				<TextBlock HorizontalAlignment="Left" Margin="17,20,0,0" TextWrapping="Wrap" Text="Description:" VerticalAlignment="Top" Height="20" FontWeight="Bold"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,40,0,0" TextWrapping="Wrap" Text="This tool will shift colors of images of the selected type and games.  Set the colorshift below.  This must be a number between 0 and 360.  It will save the original images so you can revert later if necessary." VerticalAlignment="Top" Width="500"/>
				<TextBox Name="BoxColorShift" HorizontalAlignment="Left" Height="25" Margin="77,119,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="50"/>
				<TextBlock HorizontalAlignment="Left" Margin="17,124,0,-11.8" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Height="20" Text="Colorshift"/>
			</Grid>
		</TabItem>
	</TabControl>
    <StackPanel Orientation="Horizontal" Margin="100,370,0,0">
		<Border BorderBrush="{DynamicResource NormalBorderBrush}" BorderThickness="1" Margin="0,0,40,25" CornerRadius="8">
			<Button Content="Process Images" VerticalAlignment="Top" Name="ButtonProcessImages" IsDefault="True"/>
		</Border>
		<Border BorderBrush="{DynamicResource NormalBorderBrush}" BorderThickness="1" Margin="0,0,40,25" CornerRadius="8">
			<Button Content="Revert Images" VerticalAlignment="Top" Name="ButtonRevertImages" IsDefault="False"/>
		</Border>
		<Border BorderBrush="{DynamicResource NormalBorderBrush}" BorderThickness="1" Margin="0,0,40,25" CornerRadius="8">
			<Button Content="Delete Backup" VerticalAlignment="Top" Name="ButtonDelBackup" IsDefault="False"/>
		</Border>
	</StackPanel>
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
    $Window.Width = 600
    $Window.Height = 450
    $Window.Title = "Game Media Processor"
    $Window.WindowStartupLocation = "CenterScreen"

    # Handler for pressing "Process Images" button
    
	$ButtonProcessImages.Add_Click(
    {
        # Get the variables from the controls
        $GameSelection = $CbGameSelection.SelectedIndex
        $MediaTypeSelection = $CbMediaType.SelectedIndex
		$ToolSelection = $ControlTools.SelectedIndex

        # Set GameDatabase
        switch ($GameSelection) {
            0 {
                $GameDatabase = $PlayniteApi.Database.Games
                $__logger.Info("Game Media Processor - Game Selection: `"AllGames`"")
            }
            1 {
                $GameDatabase = $PlayniteApi.MainView.SelectedGames
                $__logger.Info("Game Media Processor - Game Selection: `"SelectedGames`"")
            }
        }

        # Set Media Type
        switch ($MediaTypeSelection) {
            0 { 
                $MediaType = "Cover"
                $OptimizedSize = 1
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
            1 {
                $MediaType = "Background"
                $OptimizedSize = 4
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
            2 {
                $MediaType = "Icon"
                $OptimizedSize = 0.1
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
			3 {
				$MediaType = "Logo"
                $OptimizedSize = 0.2
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
			}
        }

        # Set Parameters
		switch ($ToolSelection) {
			0 { # Tool #0: Resize
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Resize`"")
				$Width = $BoxResizeWidth.Text
				$Height = $BoxResizeHeight.Text

				if ( ($Width -match "^\d+$") -and ($Height -match "^\d+$") )
				{
					# Set tag Name
					$TagTitle = "Resize"
					$TagDescription = "$Width`x$height"
					$TagName = "$TagTitle`: $MediaType $TagDescription"
					
					# Set function to determine tag operation
					$ToolFunctionName = "ToolResize"
					$AdditionalOperation = "GetDimensions"
					$ExtraParameters = @(
						$Width,
						$Height
					)

					# Start Game Media Processor function
					$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation, $ExtraParameters`"")
					Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation $ExtraParameters
				}
				else
				{
					$__logger.Info("Game Media Processor - Invalid Input `"$Width`", `"$Height`"")
					$PlayniteApi.Dialogs.ShowMessage("Invalid Input in Width and height Input boxes.", "Game Media Processor");
				}
			}
			1 { # Tool #1: Resize & Crop
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Resize and Crop`"")
				$Width = $BoxCropWidth.Text
				$Height = $BoxCropHeight.Text
				$Gravity = $BoxCropGravity.Text
				$GravityOptions = @(
					"Northwest",
					"North",
					"Northeast",
					"East",
					"Southeast",
					"South",
					"Southwest",
					"West",
					"Center"
				)

				if ( ($Width -match "^\d+$") -and ($Height -match "^\d+$") )
				{
					# Set tag Name
					$TagTitle = "Resize and Crop"
					$TagDescription = "$Width`x$height"
					$TagName = "$TagTitle`: $MediaType $TagDescription"
					
					# Set function to determine tag operation
					$ToolFunctionName = "ToolResizeCrop"
					$AdditionalOperation = "GetDimensions"
					$ExtraParameters = @(
						$Width,
						$Height
					)
					
					if ($GravityOptions.Contains($Gravity))
					{
						# Start Game Media Processor function
						$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation, $ExtraParameters`"")
						Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation $ExtraParameters
					}
					else
					{
						$__Logger.Info("Game Media Processor - Invalid Input `"$Gravity`"")
						$PlayniteApi.Dialogs.ShowMessage("Invalid Input in Gravity Input box.", "Game Media Processor");
					}
					
				}
				else
				{
					$__logger.Info("Game Media Processor - Invalid Input `"$Width`", `"$Height`"")
					$PlayniteApi.Dialogs.ShowMessage("Invalid Input in Width and height Input boxes.", "Game Media Processor");
				}
			}
			2 { # Tool #2: Trim
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Trim`"")
                
                # Set tag Name
                $TagTitle = "Trim"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolTrim"
				$AdditionalOperation = "GetDimensions"
				                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			3 { # Tool #3: Flip
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Flip`"")
                
                # Set tag Name
                $TagTitle = "Flip"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolFlip"
				$AdditionalOperation = "GetDimensions"
				                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			4 { # Tool #4: Fade
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Fade`"")
				$FadeLevel = $BoxFadeEdges.Text
				
				if (($FadeLevel -match "^\d+$") -and ([int]$FadeLevel -gt 0))
				{
					# Set tag Name
					$TagTitle = "Fade"
					$TagDescription = "$FadeLevel"
					$TagName = "$TagTitle`: $MediaType $TagDescription"
					
					# Set function to determine tag operation
					$ToolFunctionName = "ToolFade"
					$AdditionalOperation = "GetDimensions"
					$ExtraParameters = @(
						$FadeLevel
					)

					# Start Game Media Processor function
					$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation, $ExtraParameters`"")
					Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation $ExtraParameters
				}
				else
				{
					$__logger.Info("Game Media Processor - Invalid Input `"$FadeLevel`"")
					$PlayniteApi.Dialogs.ShowMessage("Invalid Input in Fade Level Input box.", "Game Media Processor");
				}
			}
			5 { # Tool #5: Grayscale
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Grayscale`"")
                
                # Set tag Name
                $TagTitle = "Grayscale"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolGrayscale"
				$AdditionalOperation = "GetDimensions"
				                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			6 { # Tool #6: Colorshift
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Colorshift`"")
				if ([float]$BoxColorShift.Text -lt 180)
				{
					$ColorAngle = ((([float]$BoxColorShift.Text * 100)/180) + 100)
				}
				else
				{
					$ColorAngle = ((([float]$BoxColorShift.Text * 100)/180) - 100)
				}
				$ColorAngle = [math]::Round($ColorAngle,2)
				
				if ($ColorAngle -le 200 -and $ColorAngle -ge 0)
				{
					# Set tag Name
					$TagTitle = "Colorshift"
					$TagDescription = "$ColorAngle"
					$TagName = "$TagTitle`: $MediaType $TagDescription"
					
					# Set function to determine tag operation
					$ToolFunctionName = "ToolColorShift"
					$AdditionalOperation = "GetDimensions"
					$ExtraParameters = @(
						,$ColorAngle
					)

					# Start Game Media Processor function
					$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation, $ExtraParameters`"")
					Invoke-GameMediaProcessor $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation $ExtraParameters
				}
				else
				{
					$__logger.Info("Game Media Processor - Invalid Input `"$Colorshift`"")
					$PlayniteApi.Dialogs.ShowMessage("Invalid Input in Colorshift Input box.", "Colorshift");
				}
			}
		}
    })
	
	# Handler for pressing "Revert Images" button
    $ButtonRevertImages.Add_Click(
    {
        # Get the variables from the controls
        $GameSelection = $CbGameSelection.SelectedIndex
        $MediaTypeSelection = $CbMediaType.SelectedIndex
		$ToolSelection = $ControlTools.SelectedIndex

        # Set GameDatabase
        switch ($GameSelection) {
            0 {
                $GameDatabase = $PlayniteApi.Database.Games
                $__logger.Info("Game Media Processor - Game Selection: `"AllGames`"")
            }
            1 {
                $GameDatabase = $PlayniteApi.MainView.SelectedGames
                $__logger.Info("Game Media Processor - Game Selection: `"SelectedGames`"")
            }
        }

        # Set Media Type
        switch ($MediaTypeSelection) {
            0 { 
                $MediaType = "Cover"
                $OptimizedSize = 1
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
            1 {
                $MediaType = "Background"
                $OptimizedSize = 4
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
            2 {
                $MediaType = "Icon"
                $OptimizedSize = 0.1
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
			3 {
                $MediaType = "Logo"
                $OptimizedSize = 0.2
                $__logger.Info("Game Media Processor - Media Selection: `"$MediaType`"")
            }
        }

        # Set Parameters
		switch ($ToolSelection) {
			0 { # Tool #0: Resize
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Resize`"")
				# Set tag Name
				$TagTitle = "Resize Revert"
				$TagName = "$TagTitle`: $MediaType $TagDescription"
				
				# Set function to determine tag operation
				$ToolFunctionName = "ToolResizeRevert"
				$AdditionalOperation = "GetDimensions"
				
					# Start Game Media Processor function
					$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
					Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
			}
			1 { # Tool #1: Resize and Crop
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Resize and Crop`"")
				# Set tag Name
				$TagTitle = "Resize and Crop Revert"
				$TagName = "$TagTitle`: $MediaType $TagDescription"
				
				# Set function to determine tag operation
				$ToolFunctionName = "ToolResizeCropRevert"
				$AdditionalOperation = "GetDimensions"
				
					# Start Game Media Processor function
					$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
					Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
			}
			2 { # Tool #2: Trim
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Trim`"")
                
                # Set tag Name
                $TagTitle = "Trim Revert"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolTrimRevert"
				$AdditionalOperation = "GetDimensions"
                
                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			3 { # Tool #3: Flip
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Flip`"")
                
                # Set tag Name
                $TagTitle = "Flip Revert"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolFlipRevert"
				$AdditionalOperation = "GetDimensions"
                
                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			4 { # Tool #4: Fade
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Fade`"")
                
                # Set tag Name
                $TagTitle = "Fade Revert"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolFadeRevert"
				$AdditionalOperation = "GetDimensions"
                
                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			5 { # Tool #5: Grayscale
                
                $__logger.Info("Game Media Processor - Tool Selection: `"Grayscale`"")
                
                # Set tag Name
                $TagTitle = "Grayscale Revert"
                $TagDescription = ""
                $TagName = "$TagTitle`: $MediaType $TagDescription"
                
                # Set function to determine tag operation
                $ToolFunctionName = "ToolGrayscaleRevert"
				$AdditionalOperation = "GetDimensions"
                
                
                # Start Game Media Processor function
                $__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
            }
			6 { # Tool #6: Colorshift
					
				$__logger.Info("Game Media Processor - Tool Selection: `"Colorshift`"")
				
				# Set tag Name
				$TagTitle = "Colorshift"
				$TagDescription = "$ColorAngle"
				$TagName = "$TagTitle`: $MediaType $TagDescription"
				
				# Set function to determine tag operation
				$ToolFunctionName = "ToolColorShiftRevert"
				$AdditionalOperation = "GetDimensions"
				
				# Start Game Media Processor function
				$__logger.Info("Game Media Processor - Starting Function with parameters `"$MediaType, $TagName, $ToolFunctionName, $AdditionalOperation`"")
				Invoke-RevertImages $GameDatabase $MediaType $TagName $ToolFunctionName $AdditionalOperation
			}
		}
    })
	$ButtonDelBackup.Add_Click(
	{
		$Deleted = 0
		$DeleteFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU"
		$convertChoice = $PlayniteApi.Dialogs.ShowMessage("This function will delete all backup image data.
		`nChanges are not reversible.`n`nDo you wish to continue?", "Game Media Processor", 4)
		if ($convertChoice -eq "Yes")
		{
			try
			{
				$filelist = Get-ChildItem -Path $DeleteFolderPath -Include *.* -File -Recurse
			}
			catch
			{
				$PlayniteApi.Dialogs.ShowMessage("There are no backed up images in your ExtensionsData path.", "Game Media Processor");
				continue
			}
			foreach ($file in $filelist)
			{
				$Deleted++
			}
			try
			{
				Remove-Item -LiteralPath $DeleteFolderPath -Force -Recurse
				$PlayniteApi.Dialogs.ShowMessage("Files Deleted: $Deleted", "Game Media Processor");
			}
			catch
			{
				$PlayniteApi.Dialogs.ShowMessage("No files were deleted", "Game Media Processor");
				continue
			}
			
		}
	})
    # Show Window
    $__logger.Info("Game Media Processor - Opening Window.")
    $Window.ShowDialog()
    $__logger.Info("Game Media Processor - Window closed.")
}

function Invoke-GameMediaProcessor
{
    param (
        $GameDatabase, 
        $MediaType,
        $TagName,
        $ToolFunctionName,
        $AdditionalOperation,
        $ExtraParameters
    )
	
	$script:ImagesProcessed = 0
	$ErrorActionPreference = "Continue"
	
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
                $__logger.Info("Game Media Processor - Found executable Path via registry in `"$MagickExecutablePath`".")
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
            $PlayniteApi.Dialogs.ShowMessage("Select ImageMagick executable", "Game Media Processor")
            $MagickExecutablePath = $PlayniteApi.Dialogs.SelectFile("magick|magick.exe")
            if (!$MagickExecutablePath)
            {
                exit
            }
            [System.IO.File]::WriteAllLines($MagickConfigPath, $MagickExecutablePath)
            $__logger.Info("Game Media Processor - Saved executable Path via user input in `"$MagickExecutablePath`".")
            $PlayniteApi.Dialogs.ShowMessage("Magick executable path saved", "Game Media Processor")
        }

        if (!(Test-Path $MagickExecutablePath))
        {
            [System.IO.File]::Delete($MagickConfigPath)
            $__logger.Info("Game Media Processor - Executable not found in user configured path `"$MagickExecutablePath`".")
            $PlayniteApi.Dialogs.ShowMessage("Magick executable not found in `"$MagickExecutablePath`". Please run the extension again to configure it to the correct location.", "Game Media Processor")
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
			# Set Revert File Name
			$ImageFileName = Split-Path -leaf $ImageFilePath
			
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
                $__logger.Info("Game Media Processor - `"$($game.name)`" $MediaType doesn't exist in pointed path. Property value deleted.")
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

            # Process Images
            switch ($Operation) {
				"Resize" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Resize" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					if ($cbkeepaspect.IsChecked)
					{
						try
						{
							& "$MagickExecutablePath" mogrify -quiet -resize $Width'x'$Height "$ImageFilePath"
						}
						catch
						{
							continue
						}
					}
					else
					{
						try
						{
							& "$MagickExecutablePath" mogrify -quiet -resize $Width'x'$Height`! "$ImageFilePath"
						}
						catch
						{
							continue
						}
					}
					
					$script:ImagesProcessed++
				}
				"Grayscale" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Grayscale" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					try
					{
						& "$MagickExecutablePath" mogrify -quiet -grayscale Rec709Luminance "$ImageFilePath"
					}
					catch
					{
						continue
					}
					$script:ImagesProcessed++
				}
				"Colorshift" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Colorshift" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					try
					{
						& "$MagickExecutablePath" mogrify -quiet -modulate 100,100,$ColorAngle "$ImageFilePath"
					}
					catch
					{
						continue
					}
					$script:ImagesProcessed++
				}
				"ResizeCrop" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\ResizeCrop" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					$newaspect = "$width`:$height"
					try
					{
						& "$MagickExecutablePath" mogrify -gravity $Gravity -extent $newaspect "$ImageFilePath"
					}
					catch
					{
						continue
					}
					try
					{
						& "$MagickExecutablePath" mogrify -quiet -resize $Width'x'$Height "$ImageFilePath"
					}
					catch
					{
						continue
					}
					$script:ImagesProcessed++
				}
				"Flip" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Flip" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					try
					{
						& "$MagickExecutablePath" mogrify -flop "$ImageFilePath"
					}
					catch
					{
						continue
					}
					$script:ImagesProcessed++
				}
				"Fade" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Fade" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					try
					{
						& "$MagickExecutablePath" convert -quiet "$ImageFilePath" -bordercolor black -fill white `( +clone -colorize 100 -shave $FadeLevel`x$FadeLevel -border $FadeLevel`x$FadeLevel -blur $FadeLevel`x$FadeLevel `) -alpha Off -compose copyopacity -composite "$ImageFilePath"
					}
					catch
					{
						continue
					}
					$script:ImagesProcessed++
				}
				"Trim" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Trim" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (!(Test-Path -Path $RevertFolderPath))
					{
						md -Path $RevertFolderPath
					}
					if (!($cbnobackup.IsChecked))
					{
						if (!(Test-Path -Path $RevertFilePath))
						{
							[System.IO.File]::Copy($ImageFilePath, $RevertFilePath)
						}
					}
					try
					{
						& "$MagickExecutablePath" convert -quiet "$ImageFilePath" -trim "$ImageFilePath"
					}
					catch
					{
						continue
					}
					$script:ImagesProcessed++
				}
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
        $__logger.Info("Game Media Processor - Games with tool tag `"$TagName`" at finish: Selection $($GamesToolTagSelection.Count), All $($GamesToolTagAll.Count)")

        # Add information to results
        $Results += "`n`n$TagName`n`nImages Processed: $script:ImagesProcessed"
		
        
        # Remove tool tag from database if 0 games have it
        if (($GamesToolTagAll.count -eq 0) -and ($GamesToolTagSelection.count -eq 0))
        {
            $PlayniteApi.Database.Tags.Remove($ToolTagId)
            $__logger.Info("Game Media Processor - Removed tool tag `"$TagName`" from database")
        }
    }

	# Show Results
    $__logger.Info("Game Media Processor - $($Results -replace "`n", ', ')")
    $PlayniteApi.Dialogs.ShowMessage("$Results", "Game Media Processor");
}

function Invoke-RevertImages
{
    param (
        $GameDatabase, 
        $MediaType,
        $TagName,
        $ToolFunctionName,
        $AdditionalOperation,
        $ExtraParameters
    )
	
	# Set Counters
	$script:ImagesProcessed = 0
	
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
			# Set Image Filename
			$ImageFileName = Split-Path -leaf $ImageFilePath
			
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
                $__logger.Info("Game Media Processor - `"$($game.name)`" $MediaType doesn't exist in pointed path. Property value deleted.")
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

            # Process Images
			switch ($Operation) {
				"Resize" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Resize" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
				"Grayscale" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Grayscale" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
				"Colorshift" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Colorshift" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
				"ResizeCrop" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\ResizeCrop" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
				"Flip" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Flip" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
				"Fade" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Fade" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
				"Trim" {
					$RevertFolderPath = Join-Path $CurrentExtensionDataPath -ChildPath "ImagesBU\Trim" | Join-Path -ChildPath $($game.Id)
					$RevertFilePath = Join-Path $RevertFolderPath -ChildPath $ImageFileName
					if (Test-Path -Path $RevertFilePath)
					{
						[System.IO.File]::Delete($ImageFilePath)
						[System.IO.File]::Move($RevertFilePath, $ImageFilePath)
						$script:ImagesProcessed++
					}
				}
			}
        }
        else
        {
            # Add "No Media Tag"
            Add-TagToGame $game $tagNoMediaIds
        }
    }
	
    # Get information of tool Tag
    if ($TagName)
    {
        $GamesToolTagSelection = $GameDatabase | Where-Object {$_.TagIds -contains $ToolTagId.Guid}
        $GamesToolTagAll = $PlayniteApi.Database.Games | Where-Object {$_.TagIds -contains $ToolTagId.Guid}
        $__logger.Info("Game Media Processor - Games with tool tag `"$TagName`" at finish: Selection $($GamesToolTagSelection.Count), All $($GamesToolTagAll.Count)")

        # Add information to results
        $Results += "$TagName`n`nImages Selected: $($GameDatabase.count)`n`nImages Processed: $script:ImagesProcessed"
		
        # Remove tool tag from database if 0 games have it
        if (($GamesToolTagAll.count -eq 0) -and ($GamesToolTagSelection.count -eq 0))
        {
            $PlayniteApi.Database.Tags.Remove($ToolTagId)
            $__logger.Info("Game Media Processor - Removed tool tag `"$TagName`" from database")
        }
    }
	
    # Show Results
    $__logger.Info("Game Media Processor - $($Results -replace "`n", ', ')")
	$PlayniteApi.Dialogs.ShowMessage("$Results", "Game Media Processor");
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
        $global:ImageWidth = [int]$image.Width
        $Image.Dispose()
        $global:ImageSuccess = $true
    } catch {
        $global:ImageSuccess = $false
        $ErrorMessage = $_.Exception.Message
        $__logger.Error("Game Media Processor - $($game.name): Error `"$ErrorMessage`" when processing image `"$ImageFilePath`"")
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
	elseif ($MediaType -eq "Logo")
	{
		$global:ImageFilePath = [System.IO.Path]::Combine($PlayniteApi.Paths.ConfigurationPath, "ExtraMetadata", "games", $game.Id, "Logo.png")
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

function ToolResize
{
    param (
        $ImageWidth,
        $ImageHeight,
        $ExtraParameters
    )
    
    # Get extra parameters
    $Width = [int]$ExtraParameters[0]
    $Height = [int]$ExtraParameters[1]

    if (!($cbresizeshrink.IsChecked))
	{
		$global:Operation = "Resize"
	}
	elseif ( ($Width -lt $ImageWidth) -Or ($Height -lt $ImageHeight) )
    {
	    $global:Operation = "Resize"
    }
    else
    {
        continue
    }
}

function ToolResizeCrop
{
    param (
        $ImageWidth,
        $ImageHeight,
        $ExtraParameters
    )
    
    # Get extra parameters
    $Width = [int]$ExtraParameters[0]
    $Height = [int]$ExtraParameters[1]

    if (!($cbcropshrink.IsChecked))
	{
		$global:Operation = "ResizeCrop"
	}
	elseif ( ($Width -le $ImageWidth) -And ($Height -le $ImageHeight) )
    {
	    $global:Operation = "ResizeCrop"
    }
    else
    {
        $__logger.Info("Game Media Processor - Width and Height must both be larger than current image.  $game.name`"")
    }
}

function ToolGrayscale
{
	$global:Operation = "Grayscale"
}

function ToolGrayscaleRevert
{
	$global:Operation = "Grayscale"
}

function ToolResizeRevert
{
	$global:Operation = "Resize"
}

function ToolResizeCropRevert
{
	$global:Operation = "ResizeCrop"
}

function ToolColorShift
{
	$global:Operation = "Colorshift"
}

function ToolColorShiftRevert
{
	$global:Operation = "Colorshift"
}

function ToolFlip
{
	$global:Operation = "Flip"
}

function ToolFlipRevert
{
	$global:Operation = "Flip"
}

function ToolFade
{
	$global:Operation = "Fade"
}

function ToolFadeRevert
{
	$global:Operation = "Fade"
}

function ToolTrim
{
	$cmdOutput = & "$MagickExecutablePath" "$ImageFilePath" -format "%[hex:u.p{0,0}]\n" info:
	$lasttwo = $cmdOutput.Substring($cmdOutput.Length - 2)
	$length = $cmdOutput.Length
	if ($cbtrimtrans.IsChecked)
	{
		
		if ($cmdOutput.Length -eq 8 -and $lasttwo -eq "00")
		{
			$global:Operation = "Trim"
		}
		else
		{
			continue
		}
	}
	else
	{
		$global:Operation = "Trim"
	}
}

function ToolTrimRevert
{
	$global:Operation = "Trim"
}