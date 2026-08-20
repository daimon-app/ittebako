# P02 A-07 Android / AAB Readiness

Date: 2026-08-20  
Branch: `product/p02-sales-ready`

## Implemented

| Item | Value / evidence | Status |
| --- | --- | --- |
| Android project | `android/` | PASS (static) |
| applicationId | `jp.daimon.ittebako` | PASS (configuration) |
| namespace | `jp.daimon.ittebako` | PASS |
| version | `versionCode 1`, `versionName 1.0.0-beta.1` | PASS |
| SDK | min 24 / target 35 / compile 35 | PASS (configuration) |
| permissions | `INTERNET` only | PASS (static) |
| offline | PWA files are copied into the APK/AAB at build time | PASS (design), device UNVERIFIED |
| storage | WebView DOM storage; Android cloud backup disabled | PASS (design), device UNVERIFIED |
| import | Android system file chooser connected to HTML file input | PASS (code), device UNVERIFIED |
| icon | existing `icon-512.png` copied into generated Android resources | PASS (configuration) |
| release build | Gradle 8.9 / JDK 17 / Android SDK 35 | PASS (unsigned release bundle) |
| AAB | `android/app/build/outputs/bundle/release/app-release.aab` | PASS (generated, unsigned) |
| release signing | no key or secret committed | OWNER KEY REQUIRED / UNVERIFIED |

## Build commands

After a compatible JDK, Android SDK 35 and Gradle are available:

```powershell
cd android
gradle clean bundleRelease
```

Generated unsigned release artifact (2026-08-20):

- path: `android/app/build/outputs/bundle/release/app-release.aab`
- size: `61,109 bytes`
- SHA-256: `DB900FEB0733FEDA205DB171D4DF52D77E38291E06F29985CA9F51F3A43CCD01`
- command: `gradle clean bundleRelease`
- result: `BUILD SUCCESSFUL` (43 tasks)
- signature inspection: unsigned (production signing remains unverified)

`android/app/build/outputs/bundle/release/app-release.aab`

The repository intentionally contains no signing key, password, `local.properties`, or SDK path.

## QA commands

```powershell
& android/test-readiness.ps1
```

Device batch must verify launch, offline first launch, restart persistence, backup import, export/download behavior, back navigation, external legal links, and no unexpected permission prompt.

## Current verdict

- Static Android configuration: `PASS`
- Release build: `PASS` (unsigned bundle, actual build)
- AAB generation: `PASS` (hash and size recorded above)
- Production signing: `OWNER_PHYSICAL_ACTION_REQUIRED / UNVERIFIED`
- Signing: `OWNER_PHYSICAL_ACTION_REQUIRED` only when a production key is created/selected
- Android device QA: `OWNER_PHYSICAL_ACTION_REQUIRED / UNVERIFIED`

No signed-release or device-PASS claim may be made until production signing and device evidence exist.

## Security note (2026-08-20)

`index.html` (the same asset copied into the APK/AAB, PASS above) had a P0 fix for unsafe imported/migrated memo id interpolation into inline `onclick` attributes (attribute breakout / JS injection via a crafted backup file or legacy `localStorage` value). Fixed at the single normalization choke point (`normalizeMemo`/`sanitizeId` in `index.html`) that all load/import/migration paths already funnel through; no Android-specific code changed. See `docs/A01_A06_DECISION_LOG.md` (2026-08-20 entry) and `tests/id-sanitize-qa.html` (12/12 PASS) for details.
