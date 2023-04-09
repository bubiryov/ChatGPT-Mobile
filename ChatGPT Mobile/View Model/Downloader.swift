//
//  Downloader.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 09.04.2023.
//

import Foundation
import SwiftUI

class Downloader {
    
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
