import Foundation
import SwiftUI

struct FishState: Codable {
    var id: UUID = UUID()
    var birthDate: Date = Date()
    var lastFedDate: Date? = nil
    var feedCount: Int = 0
    var colorR: Double = Double.random(in: 0.4...0.9)
    var colorG: Double = Double.random(in: 0.4...0.9)
    var colorB: Double = Double.random(in: 0.4...0.9)
    
    // Core parameters
    var maxFeeds = 365
    
    var currentSize: Double {
        let baseSize = 0.2 // Starts at 20% size
        let growth = Double(min(feedCount, maxFeeds)) / Double(maxFeeds) * 0.8
        return baseSize + growth
    }
    
    var color: Color {
        Color(red: colorR, green: colorG, blue: colorB)
    }
    
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    var isHungry: Bool {
        guard let lastFed = lastFedDate else { return true }
        // If not fed in the current calendar day, the fish is hungry!
        return !Calendar.current.isDateInToday(lastFed)
    }
    
    /// Procedurally mix and evolve the fish's colors upon feeding
    mutating func feed() {
        lastFedDate = Date()
        if feedCount < maxFeeds {
            feedCount += 1
            
            // Subtly evolve the color R, G, B components (+/- 0.1, clamped between 0.3 and 1.0)
            colorR = max(0.3, min(1.0, colorR + Double.random(in: -0.12...0.12)))
            colorG = max(0.3, min(1.0, colorG + Double.random(in: -0.12...0.12)))
            colorB = max(0.3, min(1.0, colorB + Double.random(in: -0.12...0.12)))
        }
    }
}

class FishManager: ObservableObject {
    static let shared = FishManager()
    
    @Published var fish: FishState
    
    private let saveKey = "AuraFishState"
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode(FishState.self, from: data) {
            self.fish = decoded
        } else {
            // Birth a brand-new baby fish!
            self.fish = FishState()
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(fish) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func feedFish() {
        fish.feed()
        save()
        
        // Haptic feedback for feeding (watchOS native haptic)
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #endif
    }
    
    /// Resets the game to start with a brand new fish
    func resetGame() {
        fish = FishState()
        save()
    }
}
