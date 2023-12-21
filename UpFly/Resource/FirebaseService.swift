//
//  FirebaseService.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/4/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    
    private init() {}
    
    func checkRoomExists(roomCode: String, completion: @escaping (Bool) -> Void) {
        let roomCollection = Firestore.firestore().collection("Room")
        
        roomCollection.document(roomCode).getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func createRoom(roomCode: String) {
        let roomCollection = Firestore.firestore().collection("Room")
        
        roomCollection.document(roomCode).setData(["created_at": FieldValue.serverTimestamp()])
    }
}
