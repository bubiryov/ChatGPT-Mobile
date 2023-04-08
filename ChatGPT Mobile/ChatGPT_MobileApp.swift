//
//  ChatGPT_MobileApp.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import SwiftUI

@main
struct ChatGPT_MobileApp: App {
    
    @StateObject var vm = ChatGPTMobileViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
