//
//  Config.swift
//  PhotoMomento
//
//  Created by Umesh Basnet on 2025-07-25.
//

import Foundation

struct Config {
    static var SUPABASE_URL: String {
        let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
        print(url)
        return "https://\(url)"
    }
    
    static var SUPABASE_KEY: String {
        Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String ?? ""
    }
}
