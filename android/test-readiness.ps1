$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot

$required = @(
    'android/settings.gradle',
    'android/build.gradle',
    'android/app/build.gradle',
    'android/app/src/main/AndroidManifest.xml',
    'android/app/src/main/java/jp/daimon/ittebako/MainActivity.java',
    'android/app/src/main/res/values/styles.xml',
    'index.html',
    'manifest.json',
    'icon-512.png'
)

$missing = @($required | Where-Object { -not (Test-Path -LiteralPath (Join-Path $root $_) -PathType Leaf) })
if ($missing.Count) { throw "Missing Android readiness files: $($missing -join ', ')" }

[xml](Get-Content -Raw -Encoding UTF8 (Join-Path $root 'android/app/src/main/AndroidManifest.xml')) | Out-Null
[xml](Get-Content -Raw -Encoding UTF8 (Join-Path $root 'android/app/src/main/res/values/styles.xml')) | Out-Null

$appGradle = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'android/app/build.gradle')
@(
    "applicationId 'jp.daimon.ittebako'",
    'minSdk 24',
    'targetSdk 35',
    'versionCode 1',
    "versionName '1.0.0-beta.1'"
) | ForEach-Object {
    if (-not $appGradle.Contains($_)) { throw "Missing Android configuration: $_" }
}

$manifest = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'android/app/src/main/AndroidManifest.xml')
if ($manifest -match 'READ_|WRITE_|CAMERA|LOCATION|RECORD_AUDIO|READ_CONTACTS') {
    throw 'Unexpected sensitive Android permission detected'
}

$activity = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'android/app/src/main/java/jp/daimon/ittebako/MainActivity.java')
@('setDomStorageEnabled(true)', 'setAllowUniversalAccessFromFileURLs(false)', 'MIXED_CONTENT_NEVER_ALLOW') | ForEach-Object {
    if (-not $activity.Contains($_)) { throw "Missing WebView safety setting: $_" }
}

'P02_ANDROID_READINESS_STATIC_TESTS_OK'

