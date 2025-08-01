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
    @Published var remoteImage: UIImage?

    private var memoryToEdit: Memory?

    init(editMemory: Memory? = nil) {
        if editMemory != nil {
            self.memoryToEdit = editMemory
            self.title = editMemory!.title
            self.description = editMemory!.description
        }
    }

    private let memoryService = MemoryService.shared

    func loadImage() async {
        defer {}
        isImageLoading = true
        guard let imageSelection = imageSelection else { return }
        if let data = try? await imageSelection.loadTransferable(
            type: Data.self)
        {
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }

            }
        }
    }

    func loadRemoteImage() async {
        guard let urlString = memoryToEdit?.imageUrl,
            let url = URL(string: urlString)
        else {
            return
        }
        defer {
            isImageLoading = false
        }
        isImageLoading = true

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                self.remoteImage = downloadedImage  // Store the remote image
            } else {
                print("Could not create UIImage from data for remote image.")
                self.errorMessage = "Failed to load remote image."
            }
        } catch {
            print("Error loading remote image: \(error.localizedDescription)")
            self.errorMessage = "Failed to load image from URL."
        }

    }
    
    func savememory() async {
        if let memoryToEdit = memoryToEdit {
            await editMemory(memoryToEdit: memoryToEdit)
        } else {
            await addMemory()
        }
    }
    

    private func addMemory() async {
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

    private func editMemory(memoryToEdit: Memory) async {

        defer {
            isLoading = false
        }
        isLoading = true
        guard !title.isEmpty, !description.isEmpty else {
            errorMessage = "Please fill all required fields."
            return
        }
        do {
            if let id = memoryToEdit.id {
                try await memoryService
                    .editMemory(
                        id: id,
                        title: title,
                        description: description,
                        imageUrl: memoryToEdit.imageUrl,
                        image: image
                    )
            }
        } catch {
            errorMessage = "Failed to edit memory. Please try again later."
        }

    }
}
