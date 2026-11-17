import SwiftUI
import AVFoundation

@main
struct AuraFishiOSApp: App {
    var body: some Scene {
        WindowGroup {
            iOSAquariumMainView()
                .preferredColorScheme(.dark)
        }
    }
}

struct SwimmingFish: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var speed: CGFloat
    var isFacingRight: Bool
}

struct iOSAquariumMainView: View {
    @State private var fishes: [SwimmingFish] = [
        SwimmingFish(position: CGPoint(x: 100, y: 200), color: .orange, size: 40, speed: 2.5, isFacingRight: true),
        SwimmingFish(position: CGPoint(x: 250, y: 380), color: .yellow, size: 32, speed: 3.0, isFacingRight: false),
        SwimmingFish(position: CGPoint(x: 180, y: 520), color: .pink, size: 45, speed: 2.0, isFacingRight: true),
        SwimmingFish(position: CGPoint(x: 300, y: 150), color: .cyan, size: 36, speed: 2.8, isFacingRight: false)
    ]
    
    @State private var foodBubbles: [CGPoint] = []
    @State private var feedCount: Int = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Deep Ocean Gradient Background
                LinearGradient(
                    colors: [Color(red: 0.02, green: 0.08, blue: 0.22), Color(red: 0.01, green: 0.03, blue: 0.10)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Floating Water Bubbles Background
                ForEach(0..<15, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: CGFloat.random(in: 6...16))
                        .position(
                            x: CGFloat((i * 30 + 20) % Int(geo.size.width)),
                            y: CGFloat((i * 60 + 50) % Int(geo.size.height))
                        )
                }
                
                // Falling Food Flakes
                ForEach(0..<foodBubbles.count, id: \.self) { index in
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 10, height: 10)
                        .shadow(color: .yellow, radius: 4)
                        .position(foodBubbles[index])
                }
                
                // Swimming Tropical Fishes
                ForEach(fishes) { fish in
                    HStack(spacing: 0) {
                        Image(systemName: "fish.fill")
                            .font(.system(size: fish.size))
                            .foregroundColor(fish.color)
                            .shadow(color: fish.color.opacity(0.6), radius: 8)
                            .scaleEffect(x: fish.isFacingRight ? 1 : -1, y: 1)
                    }
                    .position(fish.position)
                    .animation(.linear(duration: 0.1), value: fish.position)
                }
                
                // Top Overlay Control Bar
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "fish.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.cyan)
                                Text("AuraFish Studio")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Touch screen to feed tropical fishes • Feeds: \(feedCount)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.cyan.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Button(action: addFish) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Fish")
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.cyan)
                            .cornerRadius(16)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Bottom Interactive Feed Button
                    Button(action: {
                        let randomPt = CGPoint(
                            x: CGFloat.random(in: 50...(geo.size.width - 50)),
                            y: CGFloat.random(in: 100...200)
                        )
                        dropFood(at: randomPt, screenHeight: geo.size.height)
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 20))
                            Text("Feed Fishes (물고기 밥주기)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(18)
                        .shadow(color: .cyan.opacity(0.4), radius: 10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                dropFood(at: location, screenHeight: geo.size.height)
            }
            .onAppear {
                startFishAnimation(screenWidth: geo.size.width, screenHeight: geo.size.height)
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private func dropFood(at location: CGPoint, screenHeight: CGFloat) {
        foodBubbles.append(location)
        feedCount += 1
        AudioServicesPlaySystemSound(1104) // Water tap feedback
    }
    
    private func addFish() {
        let colors: [Color] = [.orange, .yellow, .pink, .cyan, .purple, .green]
        let newFish = SwimmingFish(
            position: CGPoint(x: 50, y: CGFloat.random(in: 150...500)),
            color: colors.randomElement() ?? .cyan,
            size: CGFloat.random(in: 32...48),
            speed: CGFloat.random(in: 2.0...4.0),
            isFacingRight: true
        )
        fishes.append(newFish)
    }
    
    private func startFishAnimation(screenWidth: CGFloat, screenHeight: CGFloat) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in 0..<fishes.count {
                var fish = fishes[i]
                
                // Move towards nearest food if available
                if let nearestFood = foodBubbles.first {
                    if fish.position.x < nearestFood.x {
                        fish.position.x += fish.speed
                        fish.isFacingRight = true
                    } else {
                        fish.position.x -= fish.speed
                        fish.isFacingRight = false
                    }
                    
                    if fish.position.y < nearestFood.y {
                        fish.position.y += fish.speed * 0.5
                    } else {
                        fish.position.y -= fish.speed * 0.5
                    }
                    
                    // Check if fish ate the food
                    if abs(fish.position.x - nearestFood.x) < 20 && abs(fish.position.y - nearestFood.y) < 20 {
                        foodBubbles.removeFirst()
                    }
                } else {
                    // Regular swimming wandering
                    if fish.isFacingRight {
                        fish.position.x += fish.speed
                        if fish.position.x >= screenWidth - 30 {
                            fish.isFacingRight = false
                        }
                    } else {
                        fish.position.x -= fish.speed
                        if fish.position.x <= 30 {
                            fish.isFacingRight = true
                        }
                    }
                }
                fishes[i] = fish
            }
        }
    }
}
