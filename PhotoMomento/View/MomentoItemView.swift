//
//  MomentoItemView.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-25.
//

import SwiftUI

struct MomentoItemView: View {
    let momento: Memory
    let onEdit: (Memory) -> Void
    let onDelete: (Memory) -> Void

    @State private var showSheet = false

    var body: some View {
        VStack(alignment: .leading) {

            AsyncImage(url: URL(string: momento.imageUrl)) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(12)

            } placeholder: {
                Color.gray.opacity(0.5)
                    .frame(height: 250)

            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            HStack {
                VStack(alignment: .leading) {
                    Text(momento.title)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    Text(momento.description)
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                        .lineLimit(2)
                }
                Spacer()
//                Button {
//                    showSheet = true
//                } label: {
                    Image(systemName: "ellipsis")
                        .padding(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showSheet = true
                        }
//                }
                .confirmationDialog("", isPresented: $showSheet, titleVisibility: .hidden) {
                    Button("Edit") { onEdit(momento) }
                    Button("Delete", role: .destructive) { onDelete(momento) }
                    Button("Cancel", role: .cancel) {}
                }

            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(
            color: .black.opacity(0.10), radius: 4, x: 2,
            y: 2
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 16)

    }

}

#Preview {
    MomentoItemView(
        momento: Memory(
            title: "Test", description: "Test",
            imageUrl:
                "https://imgs.search.brave.com/0yhjMO88jPzzshmQWoltcWDvpIW4aYICl8NkOqXQboA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzEzLzA5Lzk2Lzg0/LzM2MF9GXzEzMDk5/Njg0NjJfdGRrUldQ/ZHBFWlNua2F5bXpw/bDBRNG16Q2VlTnAy/THMuanBn"
        ), onEdit: { _ in },
        onDelete: { _ in }
    )

}
