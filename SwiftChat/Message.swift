import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var isIncoming: Bool
    var timestamp: Timestamp
}
