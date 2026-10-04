import SwiftUI

@main
struct AuraFishApp: App {
    init() {
        // Request notification permission and schedule weekly random alarms on startup!
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            MainFishView()
        }
    }
}
