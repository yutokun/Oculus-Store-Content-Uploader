Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Preparing input window

$form = New-Object System.Windows.Forms.Form
$form.Text = "Release Note"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true 

$notes = New-Object System.Windows.Forms.TextBox
$notes.Location = New-Object System.Drawing.Point(10, 10)
$notes.Size = New-Object System.Drawing.Size(360, 200)
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

    if ($notes.Text.Length -ge 2) {
        $notes.Text = $notes.Text.Remove(0,1)
        $notes.Text = $notes.Text.Remove($notes.Text.Length - 1, 1)
        $notes.Text = $notes.Text.Replace("\n", "`r`n")
    }

    $result = $form.ShowDialog()

    $notes.Text = $notes.Text.Replace("`r`n", "\n")
    $notes.Text = $notes.Text.Insert(0, '"')
    $notes.Text = $notes.Text.Insert($notes.Text.Length, '"')

    # Uploading

    cd -Path "PATH\TO\OVR-PLATFORM-UTIL-DIRECTORY"
    ./ovr-platform-util upload-mobile-build -c beta -n $notes.Text -a YOUR-APP-ID -s YOUR-APP-SECRET --apk "PATH\TO\APK"

    $operation = Read-Host "`nPress enter key to Exit. If you want to retry, type 'restart'."
}
while ($operation.Contains("restart"))