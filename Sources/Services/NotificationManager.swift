import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Requests local notification permission on Apple Watch
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
                // Automatically schedule the next 7 days of random feeding alarms!
                self.scheduleRandomWeeklyAlarms()
            } else if let error = error {
                print("Permission error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Schedules a unique, random-hour feeding alarm for each of the next 7 days.
    /// This runs entirely on-device and creates the perfect unpredictable "Tamagotchi" experience!
    func scheduleRandomWeeklyAlarms() {
        let center = UNUserNotificationCenter.current()
        
        // Clear all previously scheduled pending alarms to avoid duplicates
        center.removeAllPendingNotificationRequests()
        
        let calendar = Calendar.current
        let today = Date()
        
        // Schedule for the next 7 days
        for dayOffset in 1...7 {
            guard let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            
            // Generate a random hour between 10 AM (10) and 8 PM (20)
            let randomHour = Int.random(in: 10...20)
            let randomMinute = Int.random(in: 0...59)
            
            var components = calendar.dateComponents([.year, .month, .day], from: targetDate)
            components.hour = randomHour
            components.minute = randomMinute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "🫧 AuraFish 배고픔"
            content.body = "꼬르륵... 물고기가 배가 고파요! 얼른 손목을 올려 맛있는 먹이를 나누어 주세요."
            content.sound = .default
            
            let request = UNNotificationRequest(
                identifier: "AuraFish_Alarm_Day\(dayOffset)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification for day \(dayOffset): \(error.localizedDescription)")
                }
            }
        }
        
        // Also schedule a daily "Hungry Reminder" (SOS) at 9 PM (21:00) that fires if they forgot to feed the fish today
        scheduleDailySOSReminder()
    }
    
    private func scheduleDailySOSReminder() {
        let center = UNUserNotificationCenter.current()
        var components = DateComponents()
        components.hour = 21 // 9:00 PM every day
        components.minute = 0
        
        // Recurrent daily trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "⚠️ AuraFish 성장 경고"
        content.body = "아직 물고기가 오늘 밥을 먹지 못해 우울해하고 있습니다. 먹이를 주지 않으면 오늘의 성장이 반영되지 않습니다!"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "AuraFish_SOS_Reminder",
            content: content,
            trigger: trigger
        )
        
        center.add(request, withCompletionHandler: nil)
    }
}
