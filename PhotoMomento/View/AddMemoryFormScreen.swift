//
//  AddMemoryFormView.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-24.
//

import PhotosUI
import SwiftUI

@MainActor
struct AddMemoryFormScreen: View {

    @StateObject var viewModel: AddMemoryViewModel

    @Environment(\.dismiss) var dismiss
    
    init(memory: Memory? = nil){
        _viewModel = StateObject(
            wrappedValue: AddMemoryViewModel(editMemory: memory)
        )
    }
  

    var body: some View {
        ScrollView {
            VStack {
                PhotosPicker(
                    selection: $viewModel.imageSelection,
                    matching: .images
                ) {
                    if let image = viewModel.image ?? viewModel.remoteImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.bottom)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.2))
                            .overlay {
                                if viewModel.isImageLoading {
                                    ProgressView()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                        .frame(width: 100, height: 250)
                                        .padding(.bottom)
                                }
                            }
                            .frame(height: 250)
                            .padding(.bottom)
                        
                    }
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.headline)
                    TextField("", text: $viewModel.title)
                        .font(.headline)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.bottom)
                    Text("Description")
                        .font(.headline)
                    TextEditor(text: $viewModel.description)
                        .scrollContentBackground(.hidden)
                        .font(.headline)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxHeight: 100)
                    
                }
                
                Spacer()
                Button {
                    Task {
                        await viewModel.savememory()
                        if viewModel.errorMessage == nil {
                            dismiss()
                            return
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Add Memory")
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding()
            .navigationTitle("Add Memory")
            .onAppear(){
                Task {
                    await viewModel.loadRemoteImage()
                }
            }
            .onChange(of: viewModel.imageSelection) {
                Task {
                    await viewModel.loadImage()
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)

        }
    }
}

#Preview {
    AddMemoryFormScreen()
}
