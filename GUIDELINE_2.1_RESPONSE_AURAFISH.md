# AuraFish: 가이드라인 2.1 (하드웨어 페어링 오해 해소) 최종 소명 답변서

이 문서는 App Store Connect **해결 센터(Resolution Center) 답장 입력창**에 복사해서 바로 전송하실 수 있는 최종 영문 공식 답변서입니다.

---

## 📝 해결 센터(Resolution Center) 복사용 최종 영문 전문

```text
Dear App Review Team,

Thank you for your review. We appreciate the opportunity to clarify the architecture of AuraFish and answer your questions directly.

1. Response to Question 1 (Platform Scope & Clarification):
- "Is this app only for Apple Watch? Or also works on iPhone?"
AuraFish works 100% standalone on iPhone and iPad. An Apple Watch is NOT required to play or enjoy the game.
On iPhone and iPad (including the iPad Air M3 device currently being reviewed), AuraFish runs as a full interactive touch aquarium ("AuraFish Studio"). Users can tap anywhere on the screen to drop food bubbles, spawn new tropical fishes with the "Add Fish" button, and watch them swim in real time.
On Apple Watch, it provides an independent wrist-based micro-pet companion with haptic feedback.

- "Why does it say the game has to start on the Apple Watch first?"
That phrase was an erroneous legacy text from an early conceptual draft that was inadvertently included in our submission metadata. 
The game does NOT need to start on the Apple Watch first. It starts and plays immediately on iOS upon launch. We sincerely apologize for this confusion and have fully corrected and updated the App Store Description to accurately reflect the standalone iOS experience.

2. Clarification Regarding Guideline 2.1 Hardware Pairing & Demo Video:
- AuraFish contains NO Bluetooth (CoreBluetooth), NO ExternalAccessory APIs, and NO hardware pairing mechanisms. 
- Furthermore, as the review is currently conducted on an iPad Air 11-inch (M3), iPadOS does not support pairing with an Apple Watch. 
- Because AuraFish requires zero hardware pairing and functions independently on the iPad itself, a hardware pairing demonstration video is physically not applicable.

3. Quick Review Instructions on your iPad Air (M3):
You can verify the complete, standalone functionality directly on the iPad in your hands right now:
1. Launch AuraFish on the iPad Air.
2. Tap anywhere on the water to immediately drop food flakes and watch the fishes gather.
3. Tap "Add Fish" at the top right to spawn new colorful species.
4. Tap "Feed Fishes" at the bottom to feed the school.
Zero accounts, zero login, zero external hardware, and zero setup are required.

We kindly ask that you test the interactive aquarium directly on your iPad Air device and re-evaluate our submission.

Best regards,
AuraFish Developer
```
