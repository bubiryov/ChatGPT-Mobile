//
//  HomeView.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var vm: ChatGPTMobileViewModel
    @State private var text = ""
    @State var messages = [String]()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        ForEach(vm.allMessages.indices, id: \.self) { index in
                            MessageView(message: vm.allMessages[index])
                                .id(index)
                        }
                        .listRowSeparator(.hidden)
                        
                        Color.clear.frame(height: 5).id("end")
                        
                    }
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    .onChange(of: vm.chatIsLoading) { _ in
                        withAnimation {
                            scrollView.scrollTo("end", anchor: .bottom)
                        }
                    }
                }
                
                RequestField(text: $text, isLoading: vm.chatIsLoading, start: { _ in
                    let temporaryText = text
                    text = ""
                    await vm.send(text: temporaryText)
                })

            }
            .navigationTitle("ChatGPT")
        }
    }
    
//    func start(_ text: String) async {
//        guard !text.isEmpty else { return }
//        messages.append("Me: \n\(text)")
//        vm.chatIsLoading = true
//        Task {
//            if let result = await vm.send(text: text) {
//                await MainActor.run {
//                    messages.append("ChatGPT: \n\(result.choices.last?.message.content ?? "Error")")
//                    vm.chatIsLoading = false
//                }
//            }
//        }
//        self.text = ""
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatGPTMobileViewModel(loader: Downloader()))
    }
}
