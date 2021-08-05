$wc = [System.Net.WebClient]::new()
$pkgurl = 'https://github.com/hex22a/windows-deploy-script/raw/main/WindowsSensor.exe'
$publishedHash = '1B301B1151350240152A42033E532717B928130CA80EFA74C5F9A13B68F8E3D2'
$cid = 'license-key'
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($pkgurl))
$SensorLocal = 'C:\Temp\WindowsSensor.exe'

if ($FileHash.Hash -eq $publishedHash) {
    'Integrity check passed'
    if (!(Test-Path -Path 'C:\Temp' -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path 'C:\Temp' -Force
    }
    Invoke-WebRequest -UseBasicParsing -Uri $pkgurl -OutFile $SensorLocal
    & $SensorLocal /install /quiet /norestart CID=$cid
} else {
    'Integrity check failed'
}

