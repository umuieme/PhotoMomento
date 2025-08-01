//
//  MemoryListView.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-08-01.
//

import SwiftUI

struct MemoryListView: View {
    var memories: [Memory]
    let onEdit: (Memory) -> Void
    let onDelete: (Memory) -> Void

    var body: some View {

       

        List {
            ForEach(memories) { item in
                MomentoItemView(
                    momento: item,
                    onEdit: onEdit,
                    onDelete: onDelete
                )

                .background(.gray.opacity(0.04))
                .listRowSeparator(Visibility.hidden)
                .listRowInsets(.init())

            }

        }
        .listStyle(.plain)
        .background(.gray.opacity(0.04))
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MemoryListView(
        memories: Dummy.memories(),
        onEdit: { _ in },
        onDelete: { _ in }
    )
}
