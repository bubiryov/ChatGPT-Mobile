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
    @Published var chatIsLoading = false
    @Published var imageIsLoading = false
    @Published var image: UIImage? = nil
    var loader = DownloadImageAsyncImageLoader()
    
    func send(text: String) async -> ChatResult? {
        let query = ChatQuery(model: .gpt3_5Turbo0301, messages: [.init(role: "user", content: text)])
        do {
            let result = try await client.chats(query: query)
            return result
        } catch (let error) {
            print(error.localizedDescription)
            return nil
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

class DownloadImageAsyncImageLoader {
        
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadImage(url: URL) async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let image = handleResponse(data: data, response: response)
            return image
        } catch {
            throw error
        }
    }
}
