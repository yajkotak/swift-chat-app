import Foundation
import Firebase
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessage: String = ""
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        FirebaseApp.configure()
        listenForMessages()
    }
    
    func sendMessage() {
        let message = Message(text: newMessage, isIncoming: false, timestamp: Timestamp())
        db.collection("messages").addDocument(data: [
            "text": message.text,
            "isIncoming": message.isIncoming,
            "timestamp": message.timestamp
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.newMessage = ""
            }
        }
    }
    
    func listenForMessages() {
        listener = db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                self?.messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }
    
    deinit {
        listener?.remove()
    }
}
