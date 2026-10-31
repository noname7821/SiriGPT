# SiriGPT — Jailbreak Deb (iOS 14+, Rootless)

Connects Siri to ChatGPT via the OpenAI API directly. No app opens. Siri passes your query to OpenAI and speaks the answer back.

## Files
- `Makefile` — Theos build, tweak + preference bundle
- `control` — deb metadata (depends: substitute, preferenceloader)
- `Tweak.xm` — Logos hooks into SiriUI, OpenAI API client, AVSpeechSynthesizer speaks reply
- `SiriGPTPreferences.swift` — SwiftUI settings view in Settings app
- `Root.plist` / `Info.plist` — preference bundle metadata

## Build
```
cd /home/memo/Default Project/SiriGPT
export THEOS=$HOME/theos
make package
```

Output: `packages/com.ofx.sirigpt_1.2.0~ios14plus_iphoneos-arm64.deb`

Install on device:
```
dpkg -i com.ofx.sirigpt_*.deb
killall -9 SpringBoard
```

Open Settings → SiriGPT, paste your OpenAI API key, toggle on. Activate Siri and ask — Siri sends it to OpenAI directly and speaks the answer back. No app opens.

## Gotchas
- Requires an OpenAI API key (free trial credits for new accounts, then paid per use)
- SiriUI class names in Tweak.xm may need adjusting per iOS version — use class-dump to verify
- Requires internet access on the device
- API key is stored in NSUserDefaults — fine for personal use, not encrypted

6767 — ollie, out.
