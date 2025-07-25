//
//  AddMemoryViewModel.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class AddMemoryViewModel: ObservableObject {

    @Published var title: String = ""
    @Published var description: String = ""
    @Published var image: UIImage?
    @Published var isImageLoading: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var imageSelection: PhotosPickerItem?

    private let memoryService = MemoryService.shared

    func loadImage() async {
        defer {}
        isImageLoading = true
        guard let imageSelection = imageSelection else { return }
        if let data = try? await imageSelection.loadTransferable(
            type: Data.self)
        {
            if let image = UIImage(data: data) {

                self.image = image

            }
        }
    }

    func addMemory() async {
        defer {
            isLoading = false
        }
        errorMessage = nil
        isLoading = true
        guard !title.isEmpty, !description.isEmpty, let image = image else {
            errorMessage = "Please fill all required fields."
            return
        }

        do {

            try await memoryService
                .addmemory(title: title, description: description, image: image)
        } catch let error {
            print("Error adding memory: \(error.localizedDescription)")
            errorMessage = "Failed to add memory. Please try again later."
        }

    }
}
