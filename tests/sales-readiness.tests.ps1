$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
$html = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.html' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }

$broken = @()
foreach ($file in $html) {
    $text = Get-Content -Raw -Encoding UTF8 $file.FullName
    foreach ($match in [regex]::Matches($text, '(?:href|src)=["'']([^"'']+)["'']', 'IgnoreCase')) {
        $value = ($match.Groups[1].Value -split '[?#]')[0]
        if (-not $value -or $value -match '^(#|https?:|mailto:|tel:|data:|javascript:)') { continue }
        $target = Join-Path $file.DirectoryName $value
        if (-not (Test-Path -LiteralPath $target)) {
            $broken += "$($file.FullName.Substring($root.Length + 1)) -> $value"
        }
    }
}
if ($broken.Count) { throw "Broken local links/assets: $($broken -join '; ')" }

$sw = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'sw.js')
@(
    './index.html', './manifest.json', './icon-192.png', './icon-512.png',
    './legal/privacy.html', './legal/terms.html', './legal/sales.html', './legal/support.html',
    './sales/index.html', './sales/purchase-check.html'
) | ForEach-Object {
    if (-not $sw.Contains($_)) { throw "Service Worker does not cache required asset: $_" }
}
if (-not $sw.Contains('${CACHE_PREFIX}v12')) { throw 'Expected P02 cache version v12' }
if (-not $sw.Contains("event.request.mode === 'navigate'")) { throw 'Navigation network-first policy missing' }

$sales = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'sales/index.html')
$purchase = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'sales/purchase-check.html')
foreach ($token in @('一手箱', '500円', '買切り')) {
    if (-not $sales.Contains($token) -or -not $purchase.Contains($token)) {
        throw "Sales/purchase copy mismatch: $token"
    }
}
if (-not $purchase.Contains('pointer-events:none') -or -not $purchase.Contains('OWNER_INFO_REQUIRED')) {
    throw 'Unapproved payment gate is not safely disabled'
}

'P02_SALES_READINESS_TESTS_OK'
