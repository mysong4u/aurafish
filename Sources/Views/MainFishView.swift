import SwiftUI

struct MainFishView: View {
    @StateObject private var manager = FishManager.shared
    
    // Floating and bubble animation states
    @State private var fishFloatOffset: CGFloat = 0.0
    @State private var bubbleOffset1 = CGFloat.random(in: 150...200)
    @State private var bubbleOffset2 = CGFloat.random(in: 150...200)
    @State private var bubbleX1 = CGFloat.random(in: -40...40)
    @State private var bubbleX2 = CGFloat.random(in: -40...40)
    
    var body: some View {
        ZStack {
            
            // 1. Deep Ocean Background Gradient
            LinearGradient(
                colors: [Color(hex: "#051329") ?? .black, Color(hex: "#010410") ?? .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // 2. Animated Floating Bubbles (Gives the watch screen life!)
            Group {
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    .frame(width: 8, height: 8)
                    .offset(x: bubbleX1, y: bubbleOffset1)
                    .animation(.linear(duration: 4.0).repeatForever(autoreverses: false), value: bubbleOffset1)
                
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(width: 12, height: 12)
                    .offset(x: bubbleX2, y: bubbleOffset2)
                    .animation(.linear(duration: 5.5).repeatForever(autoreverses: false), value: bubbleOffset2)
            }
            
            // 3. Main Aquarium Content
            VStack(spacing: 8) {
                
                // Status Header
                HStack {
                    Image(systemName: manager.fish.isHungry ? "leaf.fill" : "checkmark.seal.fill")
                        .foregroundColor(manager.fish.isHungry ? .orange : .green)
                        .font(.footnote)
                    
                    Text(manager.fish.isHungry ? "배고픔 🫧" : "배부름 ✨")
                        .font(.system(.caption2, design: .rounded).bold())
                        .foregroundColor(manager.fish.isHungry ? .orange : .green)
                    
                    Spacer()
                    
                    Text("Day \(manager.fish.feedCount)/365")
                        .font(.system(.caption2, design: .rounded).bold())
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                
                Spacer(minLength: 2)
                
                // Procedural Glowing Fish
                ZStack {
                    // Glowing outer aura
                    FishDrawing(color: manager.fish.color)
                        .scaleEffect(manager.fish.currentSize)
                        .blur(radius: 8)
                        .opacity(manager.fish.isHungry ? 0.3 : 0.7)
                    
                    // Main Fish Body
                    FishDrawing(color: manager.fish.color)
                        .scaleEffect(manager.fish.currentSize)
                        .offset(y: fishFloatOffset)
                        .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: fishFloatOffset)
                }
                .frame(height: 70)
                
                Spacer(minLength: 2)
                
                // Interaction Controls
                if manager.fish.isHungry {
                    Button(action: feedFish) {
                        Label("먹이 주기", systemImage: "drop.fill")
                            .font(.system(.body, design: .rounded).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [manager.fish.color, .indigo],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: manager.fish.color.opacity(0.4), radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 4)
                } else {
                    VStack(spacing: 2) {
                        Text("오늘 성장 완료! 🎉")
                            .font(.system(.caption2, design: .rounded).bold())
                            .foregroundColor(.secondary)
                        Text("내일의 모핑 알림을 기다리세요.")
                            .font(.system(size: 9, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .padding(.bottom, 4)
                }
            }
            .padding(.top, 16)
        }
        .onAppear {
            // Trigger floating fish animation
            fishFloatOffset = 6.0
            
            // Trigger floating bubbles
            bubbleOffset1 = -110
            bubbleOffset2 = -110
            
            // Re-schedule alarms every time the app is opened to keep them perfectly fresh and random!
            NotificationManager.shared.scheduleRandomWeeklyAlarms()
        }
    }
    
    private func feedFish() {
        withAnimation {
            manager.feedFish()
            
            // Re-trigger bubbles splash upon feeding
            bubbleOffset1 = 120
            bubbleOffset2 = 120
            bubbleX1 = CGFloat.random(in: -40...40)
            bubbleX2 = CGFloat.random(in: -40...40)
            
            withAnimation(.linear(duration: 3.0)) {
                bubbleOffset1 = -110
                bubbleOffset2 = -110
            }
        }
    }
}

// Procedural vector drawing of our adorable baby fish!
struct FishDrawing: View {
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let w = geometry.size.width
                let h = geometry.size.height
                let cx = w / 2
                let cy = h / 2
                
                // 1. Draw Fish Tail (Fins) on the left
                path.move(to: CGPoint(x: cx - 35, y: cy))
                path.addLine(to: CGPoint(x: cx - 60, y: cy - 25))
                path.addLine(to: CGPoint(x: cx - 50, y: cy))
                path.addLine(to: CGPoint(x: cx - 60, y: cy + 25))
                path.closeSubpath()
                
                // 2. Draw Main Fish Body (Ellipse)
                path.addEllipse(in: CGRect(x: cx - 40, y: cy - 22, width: 75, height: 44))
                
                // 3. Draw Little Eye on the right
                path.addEllipse(in: CGRect(x: cx + 18, y: cy - 8, width: 6, height: 6))
            }
            .fill(color)
        }
        .frame(width: 80, height: 45)
    }
}

// Extension to convert Hex string to SwiftUI Color
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count
        let r, g, b, a: Double
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
