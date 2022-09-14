
import Foundation

struct GuestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let guestSessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}
