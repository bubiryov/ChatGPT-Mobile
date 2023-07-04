//
//  ContentView.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: ChatGPTMobileViewModel
    
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    (Label("Chat", systemImage: "text.bubble"))
                }
            ImageView()
                .tabItem {
                    (Label("Images", systemImage: "photo"))
                }
        }
        .tint(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ChatGPTMobileViewModel(loader: Downloader()))
    }
}
