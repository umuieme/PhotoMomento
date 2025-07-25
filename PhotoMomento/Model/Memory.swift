//
//  PhotoMemory.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import FirebaseFirestore

struct Memory : Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    let imageUrl: String
}
