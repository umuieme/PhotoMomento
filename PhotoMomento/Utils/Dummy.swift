//
//  Dummy.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-08-01.
//

class Dummy {
    
    static func memories() -> [Memory] {
        var memories: [Memory] = []
        
        for index in 0..<10 {
            memories.append(Memory(
                title: "Test \(index)", description: " this is long description of toronto. this is long description of toronto. this is long description of toronto.",
                imageUrl:
                    "https://imgs.search.brave.com/0yhjMO88jPzzshmQWoltcWDvpIW4aYICl8NkOqXQboA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzEzLzA5Lzk2Lzg0/LzM2MF9GXzEzMDk5/Njg0NjJfdGRrUldQ/ZHBFWlNua2F5bXpw/bDBRNG16Q2VlTnAy/THMuanBn"
            ))
        }
        return memories
        
    }
}
