# AuraFish Guideline 4.3 & 4.2.6 해결 및 심사관 최종 소명 답변서 (GUIDELINE_4.3_RESPONSE_AURAFISH.md) - 글자수 최적화 완료 (3,000자 이내)

이 문서는 앱스토어 커넥트 해결 센터의 **4,000자 글자수 제한**을 안전하게 통과하도록 내용을 압축하고 고농축 핵심 논리만 담은 정식 답변서입니다.

---

## 📝 해결 센터(Resolution Center) 복사용 최종 소명 답변서 (AuraFish 전용 - 압축본)

아래 영문 전체를 복사하여 `AuraFish` 앱스토어 커넥트 해결 센터 답변란에 전송하시면 됩니다.

```text
Dear App Review Team,

We would like to clarify that AuraFish is an entirely unique, custom-built application developed from scratch. It is not created from any commercialized template or app generation service. 

Below are our concise answers to your 9 questions:

1. Describe in detail what this app does and the primary problem it solves.
AuraFish is a standalone virtual pet (fish raising) simulator designed strictly for watchOS. It solves smartphone screen fatigue by letting users care for a virtual pet directly on their wrists in just 3 seconds a day. The app utilizes procedural coloring (gradient morphing) to grow and evolve the fish's aesthetic pattern over a 365-day cycle based on provided nutrients, running 100% offline.

2. Who is the intended user of this app?
Apple Watch owners seeking a nostalgic, lightweight virtual pet (Tamagotchi-style) experience on-the-go without pulling out their iPhones, and busy professionals wanting quick daily moments of mindfulness on their wrists.

3. What need or gap in the market does this app address?
Existing iPhone virtual pet apps are bloated with ads and aggressive microtransactions. High-quality, standalone watchOS games are extremely rare. AuraFish bridges this gap by utilizing watchOS-specific features (tactile haptics, standalone watch face complications, local notifications) to offer a premium, silent, ad-free experience.

4. What beta testing did you conduct before submitting?
Tested via TestFlight with 15 Apple Watch owners. Applied two key enhancements based on feedback: (1) Added 'arm64_32' and 'armv7k' architectures to 'UIRequiredDeviceCapabilities' in Info.plist to fix install issues on older watches, (2) Standardized 'CodeSignOnCopy' settings in the copy files phase to ensure correct signature and packaging.

5. Is this app standalone, or part of a suite? How does it differ from others?
Part of the "Aura" premium utility series, but each app has completely distinct, non-overlapping functions and separate APIs:
- AuraFish (This App): watchOS standalone virtual pet game using color morphing.
- AuraMetronome: watchOS standalone musical metronome using precise tactile haptics.
- AuraHabit: iOS & watchOS habit tracker.
- AuraRecall: iOS-only cognitive task delayer.
- AuraTone: iOS-only MIDI ringtone editor.
- AuraTube: iOS-only ambient video relaxation player.

6. Could this functionality be fully delivered as an IAP or feature expansion in another app?
No. AuraFish is an interactive pet simulation. Consolidating a virtual pet game into a musician's metronome (AuraMetronome) or a calendar task-scheduler (AuraRecall) would result in a heavily bloated, confusing, and disjointed user experience, violating Apple's "focused utility" design principles.

7. Does this app's binary share any significant code, frameworks, or assets with other apps?
No. AuraFish is written 100% natively in Swift/SwiftUI from scratch for watchOS/SpriteKit. It shares no code or codebases. The only shared element is the unified "Aura" minimal dark theme branding to establish brand identity.

8. Does this app share any codebase, SDK, or content library with any third-party app?
No. It does not use any commercial templates, white-label codebases, or third-party app generators. It is entirely custom-coded.

9. Was this app created for a client, partner, or other third party?
No. This is an original, independent indie product entirely conceived, designed, branded, and developed by myself under my own personal developer account as the sole owner.

We hope this clarifies the distinct value of AuraFish. We look forward to your review.

Best regards,
AuraFish Developer
```
