# SiriGPT — Jailbreak Deb (iOS 14+, Rootless)

Connects Siri to the ChatGPT app on your iPhone. No API key needed. Siri passes your query to ChatGPT and speaks the answer back.

## Files
- `Makefile` — Theos build, tweak + preference bundle
- `control` — deb metadata (depends: substitute, preferenceloader)
- `Tweak.xm` — Logos hooks into SiriUI, launches ChatGPT app via URL scheme, speaks reply with AVSpeechSynthesizer
- `SiriGPTPreferences.swift` — SwiftUI toggle in Settings app
- `Root.plist` / `Info.plist` — preference bundle metadata

## Build
```
cd /home/memo/Default Project/SiriGPT
export THEOS=$HOME/theos
make package
```

Output: `packages/com.ofx.sirigpt_1.1.0~ios14plus_iphoneos-arm64.deb`

Install on device:
```
dpkg -i com.ofx.sirigpt_*.deb
killall -9 SpringBoard
```

Open Settings → SiriGPT, enable the toggle. Activate Siri and ask something — it opens ChatGPT on your phone and speaks the answer back.

## Gotchas
- Requires the ChatGPT app installed from the App Store
- SiriUI class names in Tweak.xm may need adjusting per iOS version — use class-dump to verify
- ChatGPT URL scheme (`openai-chatgpt://`) may change between app versions

6767 — ollie, out.
