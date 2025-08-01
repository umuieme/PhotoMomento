
//
//  MemoryService.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class MemoryService {

    public static let shared = MemoryService()

    private let supabaseManager = SupabaseManager.shared
    private let firestore = Firestore.firestore()
    private let memoryCollectionKey = "memories"
    //    let storage = Storage.storage()

    func addmemory(title: String, description: String, image: UIImage)
        async throws
    {

        let imageLink = try await supabaseManager.uploadImage(image)
        if let imageUrl = imageLink, !imageUrl.isEmpty {

            let memory = Memory(
                title: title,
                description: description,
                imageUrl: imageUrl
            )
            try await firestore
                .collection(memoryCollectionKey)
                .addDocument(from: memory)

        }

    }

    func editMemory(
        id: String, title: String, description: String, imageUrl: String,
        image: UIImage?
    ) async throws {

        var memory = Memory(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl ?? ""
        )

        if let image = image {
            let imageUrl = try? await supabaseManager.uploadImage(image)
            if let imageUrl = imageUrl {
                memory.imageUrl = imageUrl
            }

        }

        let ref = try await firestore.collection(memoryCollectionKey).document(
            memory.id!
        )
            .setData(from: memory, merge: true)
        if image != nil && !imageUrl.isEmpty {
            try await supabaseManager.deleteImage(at: imageUrl)
        }


    }
    
    func deleteMemory(id: String, imageUrl: String) async throws {
        try await supabaseManager.deleteImage(at: imageUrl)
        
        try await firestore
            .collection(memoryCollectionKey)
            .document(id)
            .delete()
    }

    func getAllMemories() async throws -> [Memory] {

        var memories: [Memory] = []

        let snapshot =
            try await firestore
            .collection(memoryCollectionKey)
            .getDocuments()

        for document in snapshot.documents {
            guard let memory = try? document.data(as: Memory.self) else {
                continue
            }
            memories.append(memory)
        }

        return memories

    }

}
