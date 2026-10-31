# SiriGPT

Connects Siri to ChatGPT on jailbroken iOS 14+. Rootless, substitute-based. Settings in the Settings app via SwiftUI.

Build:
```
cd /home/memo/Default Project/SiriGPT
export THEOS=$HOME/theos
make package
```

Output: `packages/com.ofx.sirigpt_1.0.0~ios14plus_iphoneos-arm64.deb`

Install on device:
```
dpkg -i com.ofx.sirigpt_*.deb
killall -9 SpringBoard
```

Open Settings → SiriGPT, enter your OpenAI API key, enable the toggle. Activate Siri — your query goes to ChatGPT, the answer speaks back.

Notes:
- SiriUI class names in Tweak.xm may need adjusting per iOS version. Use class-dump to verify.
- API key is stored in NSUserDefaults.
- Requires internet access.

6767 — ollie, out.
