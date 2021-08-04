$wc = [System.Net.WebClient]::new()
$pkgurl = 'https://github.com/hex22a/windows-deploy-script/raw/main/WindowsSensor.exe'
$publishedHash = '1B301B1151350240152A42033E532717B928130CA80EFA74C5F9A13B68F8E3D2'
$cid = 'license-key'
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($pkgurl))

if ($FileHash.Hash -eq $publishedHash) {
    'Integrity check passed'
    $Response = Invoke-WebRequest -UseBasicParsing -Uri $pkgurl
    $Response
    $Stream = [System.IO.StreamWriter]::new(@'WindowsSensor.exe', $false)
    try {
        'Writing to a disc'
        $Stream.Write($Response.Content)
        'complete'
        $Stream
    }
    finally {
        $Stream.Dispose()
    }
    & '.\WindowsSensor.exe' /install /quiet /norestart CID=$cid
} else {
    'Integrity check failed'
}

