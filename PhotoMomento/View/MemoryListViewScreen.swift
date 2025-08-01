//
//  MemoryListView.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import SwiftUI

struct MemoryListViewScreen: View {
    @StateObject private var viewModel = MemoryListViewModel()
    @State private var selectedMomento: Memory? = nil
    @State private var showDeleteConfirmation: Bool = false
    @State private var memoryToDelete: Memory? = nil

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.memories.isEmpty {
                    Text("No Memories Found\nAdd a new memory by tapping the plus (+) button")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    MemoryListView(
                        memories: viewModel.memories,
                        onEdit: { memory in
                            selectedMomento = memory
                        },
                        onDelete: { memory in
                            memoryToDelete = memory
                            showDeleteConfirmation = true
                        })

                }
            }
            .padding(0)
            .background(.gray.opacity(0.04))
            .navigationTitle("My Memories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink {
                    AddMemoryFormScreen()
                } label: {
                    Image(systemName: "plus")
                }

            }
            .onAppear {
                Task {
                    await viewModel.loadMemories()
                }
            }
            .navigationDestination(
                item: $selectedMomento,
                destination: { item in
                    AddMemoryFormScreen(memory: item)
                }
            )
            .alert("Delete Memory?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    Task {
                        if let memory = memoryToDelete {
                            await viewModel.deleteMemory(memory)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }

        }
    }

}

#Preview {
    MemoryListViewScreen()
}
