$wc = [System.Net.WebClient]::new()
$pkgurl = 'https://raw.githubusercontent.com/hex22a/file-generator/main/cleanup.sh'
$publishedHash = 'DAD6999FBED132F583910E5B1C3AA759AEC0C09B982A2D382C44A0EED93EE20B'
$cid = 'some-cid'
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($pkgurl))

if ($FileHash.Hash -eq $publishedHash) {
    'Integrity check passed'
    $Response = Invoke-WebRequest -Uri $pkgurl
    $Stream = [System.IO.StreamWriter]::new('WindowsSensor.exe', $false, $Response.Encoding)
    try {
        $Stream.Write($Response.Content)
    }
    finally {
        $Stream.Dispose()
    }
    & '.\WindowsSensor.exe' /install /quiet /norestart CID=$cid
} else {
    'Integrity check failed'
}

