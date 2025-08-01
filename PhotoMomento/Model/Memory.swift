//
//  PhotoMemory.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import FirebaseFirestore

struct Memory : Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageUrl: String
}
