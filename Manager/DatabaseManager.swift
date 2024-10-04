//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by Fatih Oğuz on 2.10.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    var updatedMessagesPublisher = PassthroughSubject<[Message], Error>()
     
    func fetchAllMessages() async throws -> [Message] {
        let snapshot = try await database.collection("messages").order(by: "createdAt",descending: false).limit(to: 30).getDocuments()
        let docs = snapshot.documents
        var messages = [Message]()
        for doc in docs {
            let decoder = JSONDecoder()
            let data = doc.data()
            let text = data["text"] as? String ?? "error with text"
            let photoURL = data["photoURL"] as? String ?? "error with photoURL"
            let uid = data["uid"] as? String ?? "error with uid"
            let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
            let msg = Message(text: text, photoURL: photoURL, uid: uid, cratedAt: createdAt.dateValue())
            messages.append(msg)
        }
        listenToChangesInDatabase()
        return messages
    }
    func sendMessageToDatabase(message: Message) {
        let msgData = [
            "text": message.text,
            "photoURL": message.photoURL,
            "uid": message.uid,
            "createdAt": message.cratedAt
        ] as [String : Any]
        database.collection("messages").addDocument(data: msgData)
    }
    func listenToChangesInDatabase() {
        database.collection("messages").order(by: "createdAt",descending: false).limit(to: 30).addSnapshotListener {[weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil, let strongSelf = self else{
                return
            }
            var messages = [Message]()
            for doc in documents {
                let decoder = JSONDecoder()
                let data = doc.data()
                let text = data["text"] as? String ?? "error with text"
                let photoURL = data["photoURL"] as? String ?? "error with photoURL"
                let uid = data["uid"] as? String ?? "error with uid"
                let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
                let msg = Message(text: text, photoURL: photoURL, uid: uid, cratedAt: createdAt.dateValue())
                messages.append(msg)
            }
            strongSelf.updatedMessagesPublisher.send(messages)
        }
    }
}
