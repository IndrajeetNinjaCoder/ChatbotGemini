//
//  APIKey.swift
//  ChatbotGemini
//
//  Created by test on 20/02/25.
//

import Foundation

enum APIKey {
    // Fetch the API key from 'GenerativeAI-Info.plist'
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
            fatalError("Could not find 'GenerativeAI-Info.plist'")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Could not find API_KEY in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") {
            fatalError("Follow the instructions in 'GenerativeAI-Info.plist' to set up the API key correctly.")
        }
        
        return value
    }
}
