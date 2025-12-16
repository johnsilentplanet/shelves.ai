import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    let email: String
    var displayName: String?
    var photoURL: String?
    var isOnboarded: Bool
    
    // Gamification & Retention
    var scanCount: Int
    var joinDate: Date
    var isPro: Bool    // RevenueCat source of truth
    
    init(
        id: String,
        email: String,
        displayName: String? = nil,
        photoURL: String? = nil,
        isOnboarded: Bool = false,
        scanCount: Int = 0,
        joinDate: Date = Date(),
        isPro: Bool = false
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.isOnboarded = isOnboarded
        self.scanCount = scanCount
        self.joinDate = joinDate
        self.isPro = isPro
    }
}
