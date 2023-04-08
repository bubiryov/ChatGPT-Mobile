//
//  ChatGPTMobileViewModel.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import Foundation
import OpenAI

final class ChatGPTMobileViewModel: ObservableObject {
        
    var client = OpenAI(apiToken: "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")
    
    func send(text: String) async -> ChatResult? {
        let query = ChatQuery(model: .gpt3_5Turbo0301, messages: [.init(role: "user", content: text)])
//        print(query.messages.first?.content)
        do {
            let result = try await client.chats(query: query)
            return result
        } catch (let error) {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
