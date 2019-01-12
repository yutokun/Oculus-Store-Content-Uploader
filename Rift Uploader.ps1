Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Preparing input window

$form = New-Object System.Windows.Forms.Form
$form.Text = "Enter App Information"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true 

$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "Version"
$versionLabel.Location = New-Object System.Drawing.Point(10, 14)
$versionLabel.Size = New-Object System.Drawing.Size(55, 12)
$form.Controls.Add($versionLabel)

$versionText = New-Object System.Windows.Forms.TextBox
$versionText.Location = New-Object System.Drawing.Point(70,10)
$form.Controls.Add($versionText)

$notesLabel = New-Object System.Windows.Forms.Label
$notesLabel.Text = "Release Note"
$notesLabel.Location = New-Object System.Drawing.Point(10, 50)
$notesLabel.Size = New-Object System.Drawing.Size(100, 12)
$form.Controls.Add($notesLabel)

$notes = New-Object System.Windows.Forms.TextBox
$notes.Location = New-Object System.Drawing.Point(10, 70)
$notes.Size = New-Object System.Drawing.Size(360, 135)
$notes.Multiline = $true
$form.Controls.Add($notes)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(150, 225)
$OKButton.Size = New-Object System.Drawing.Size(100, 25)
$OKButton.Text = "Upload"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($OKButton)

do
{
    echo "`nStart uploading APP NAME"

    if ($versionText.Text.Length -ge 2) {
        $versionText.Text = $versionText.Text.Remove(0, 1)
        $versionText.Text = $versionText.Text.Remove($versionText.Text.Length - 1, 1)
    }

    if ($notes.Text.Length -ge 2) {
        $notes.Text = $notes.Text.Remove(0,1)
        $notes.Text = $notes.Text.Remove($notes.Text.Length - 1, 1)
        $notes.Text = $notes.Text.Replace("\n", "`r`n")
    }

    $result = $form.ShowDialog()

    $versionText.Text = $versionText.Text.Insert(0, '"')
    $versionText.Text = $versionText.Text.Insert($versionText.Text.Length, '"')
    $notes.Text = $notes.Text.Replace("`r`n", "\n")
    $notes.Text = $notes.Text.Insert(0, '"')
    $notes.Text = $notes.Text.Insert($notes.Text.Length, '"')

    # Uploading

    cd -Path "PATH\TO\OVR-PLATFORM-UTIL-DIRECTORY"
    ./ovr-platform-util upload-rift-build -a YOUR-APP-ID -s YOUR-APP-SECRET -c beta -f true -v $versionText.Text -d "PATH\TO\BUILD\DIRECTORY" -l "EXE-NAME.EXE" -n $notes.Text
    
    $operation = Read-Host "`nPress enter key to Exit. If you want to retry, type 'restart'."
} while ($operation.Contains("restart"))