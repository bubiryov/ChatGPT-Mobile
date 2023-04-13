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
    var loader: Downloader
    
    init(loader: Downloader) {
        self.loader = loader
    }

    @Published var chatIsLoading = false
    @Published var imageIsLoading = false
    @Published var image: UIImage? = nil
    @Published var allMessages: [Any] = []
    @Published var chats: [Chat] = []
    
    func send(text: String) async {
        guard !text.isEmpty else { return }
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        let chat = Chat(role: .user, content: text)
        await MainActor.run {
            chats.append(chat)
        }
        let query = ChatQuery(model: .gpt3_5Turbo0301, messages: .init(chats))
        await MainActor.run {
            withAnimation {
                allMessages.append(query)
            }
            chatIsLoading = true
        }
        do {
            let result = try await client.chats(query: query)
            let chatResult = Chat(role: .assistant, content: result.choices[0].message.content)
            await MainActor.run {
                withAnimation {
                    allMessages.append(result)
                    chats.append(chatResult)
                }
                chatIsLoading = false
            }
        } catch (let error) {
            print(error.localizedDescription)
            await MainActor.run {
                chatIsLoading = false
            }
            return
        }
    }
    
    func getImage(prompt: String) async {
        guard !prompt.isEmpty else { return }
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
            imageIsLoading = false
            return
        }
    }
}
