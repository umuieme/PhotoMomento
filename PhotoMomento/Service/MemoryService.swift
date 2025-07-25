import FirebaseFirestore
import FirebaseStorage
//
//  MemoryService.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//
import Foundation
import UIKit

class MemoryService {

    public static let shared = MemoryService()
    
    private let supabaseManager = SupabaseManager.shared
    private let firestore = Firestore.firestore()
    private let memoryCollectionKey = "memories"
    //    let storage = Storage.storage()

    func addmemory(title: String, description: String, image: UIImage) async throws {
        
        let imageLink =  try await supabaseManager.uploadImage(image)
            if let imageUrl = imageLink, !imageUrl.isEmpty {

                let memory = Memory(
                    title: title,
                    description: description,
                    imageUrl: imageUrl
                )
                try  firestore
                    .collection(memoryCollectionKey)
                    .addDocument(from: memory)

            }
       

    }
    
    func getAllMemories() async throws -> [Memory] {
        
        var memories: [Memory] = []
        
        let snapshot = try await firestore
            .collection(memoryCollectionKey)
            .getDocuments()
        
        for document in snapshot.documents {
            guard let memory = try? document.data(as: Memory.self) else { continue }
            memories.append(memory)
        }
        
        return memories
        
    }

}
