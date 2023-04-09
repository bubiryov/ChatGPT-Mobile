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
                List {
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.inset)
                
                RequestField(text: $text, isLoading: vm.chatIsLoading, start: { _ in await start(text) })

            }
            .navigationTitle("ChatGPT")
        }
    }
    
    func start(_ text: String) async {
        guard !text.isEmpty else { return }
        messages.append("Me: \n\(text)")
        vm.chatIsLoading = true
        Task {
            if let result = await vm.send(text: text) {
                await MainActor.run {
                    messages.append("ChatGPT: \n\(result.choices.last?.message.content ?? "Error")")
                    vm.chatIsLoading = false
                }
            }
        }
        self.text = ""
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatGPTMobileViewModel())
    }
}

struct RequestField: View {
    
    @EnvironmentObject var vm: ChatGPTMobileViewModel
    @Binding var text: String
    var isLoading: Bool
    var start: ((String) async -> Void)
    
    var body: some View {
        HStack {
            TextField("Write here", text: $text)
                .padding(.leading)
                .frame(maxHeight: .infinity)
                .background(Color.secondary)
                .cornerRadius(20)
            
            Button {
                if !isLoading {
                    Task {
                        await start(text)
                    }
                }
            } label: {
                if !isLoading {
                    Image(systemName: "paperplane")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.secondary)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaledToFit()
                        .frame(width: 30)
                }
                
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
        .padding(.bottom)
    }
}
