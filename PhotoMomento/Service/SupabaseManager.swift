//
//  SupabaseManager.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import Supabase
import Storage
import Foundation
import UIKit


class SupabaseManager {
    static let shared = SupabaseManager()
    private let bucketName = "test"
    let supabase: SupabaseClient

    private init() {
        supabase = SupabaseClient(
            supabaseURL: URL(string: Config.SUPABASE_URL)!,
            supabaseKey: Config.SUPABASE_KEY
        )
    }

    func uploadImage(_ image: UIImage) async throws -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        let filename = "\(UUID().uuidString).jpg"
        try await supabase.storage
            .from(bucketName)
            .upload(filename, data: data)
        let url = try supabase.storage
            .from(bucketName)
            .getPublicURL(path: filename).absoluteString
        print(url)
        return url
    }

    func deleteImage(at url: String) async throws {
        guard let filename = URL(string: url)?.lastPathComponent else { return }
        try await supabase.storage.from("memories").remove(paths: [filename])
    }
}
