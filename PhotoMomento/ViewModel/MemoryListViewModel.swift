//
//  MemoriesViewModel.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import Foundation

@MainActor
class MemoryListViewModel : ObservableObject {
    @Published var memories: [Memory] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func loadMemories() async {
        defer {
            isLoading = false
        }
        do {
            errorMessage = nil
            isLoading = true
            memories = try await MemoryService.shared.getAllMemories();
            
            print(memories.count)
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func deleteMemory(_ memory: Memory) async {
        do {
            try await MemoryService.shared
                .deleteMemory(id: memory.id!, imageUrl: memory.imageUrl)
            memories.removeAll { item in
                memory.id == item.id
            }
        } catch {
            print("Error deleting memory: \(error.localizedDescription)")
        }
    }
}
