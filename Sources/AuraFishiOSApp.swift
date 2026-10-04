import SwiftUI

// This is a minimal iOS companion wrapper required by Apple's compiler 
// to generate a valid, signable iOS binary product inside the combined archive.
@main
struct AuraFishiOSApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                Image(systemName: "applewatch")
                    .font(.system(size: 80))
                    .foregroundColor(.indigo)
                Text("AuraFish")
                    .font(.largeTitle.bold())
                Text("애플워치에서 게임을 실행해 주세요!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
