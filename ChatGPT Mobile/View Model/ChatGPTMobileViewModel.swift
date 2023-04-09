//
//  ChatGPTMobileViewModel.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import Foundation
import SwiftUI
import OpenAI

final class ChatGPTMobileViewModel: ObservableObject {
        
    var client = OpenAI(apiToken: "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")
    var loader = Downloader()

    @Published var chatIsLoading = false
    @Published var imageIsLoading = false
    @Published var image: UIImage? = nil
    @Published var allMessages: [Any] = []
    
    func send(text: String) async {
        guard !text.isEmpty else { return }
        let query = ChatQuery(model: .gpt3_5Turbo0301, messages: [.init(role: "user", content: text)])
        await MainActor.run {
            chatIsLoading = true
            withAnimation {
                allMessages.append(query)
            }
        }
        do {
            let result = try await client.chats(query: query)
            await MainActor.run {
                chatIsLoading = false
                withAnimation {
                    allMessages.append(result)
                }
            }
        } catch (let error) {
            print(error.localizedDescription)
            return
        }
    }
    
    func getImage(prompt: String) async {
        guard !prompt.isEmpty else { return }
        await MainActor.run {
            imageIsLoading = true
        }
        let query = ImagesQuery(prompt: prompt, n: 1, size: "1024x1024")
        do {
            let result = try await client.images(query: query)
            if let url = URL(string: result.data[0].url) {
                if let image = try await loader.downloadImage(url: url) {
                    await MainActor.run {
                        self.image = image
                        imageIsLoading = false
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
