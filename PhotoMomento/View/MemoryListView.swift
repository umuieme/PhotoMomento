//
//  MemoryListView.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import SwiftUI

struct MemoryListView: View {
    @StateObject private var viewModel = MemoryListViewModel()
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
                    Text("No memories found.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.memories) { item in
                            MomentoItemView(momento: item)
                                .listRowSeparator(Visibility.hidden)
                                .listRowInsets(.init())

                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .background(.gray.opacity(0.04))

                    }
                    .listStyle(.plain)
                    .background(.gray.opacity(0.04))
                    .scrollIndicators(.hidden)

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
                    print(Config.SUPABASE_KEY)
                    print(Config.SUPABASE_URL)
                    await viewModel.loadMemories()
                }
            }
        }
    }
    
}

#Preview {
    MemoryListView()
}
