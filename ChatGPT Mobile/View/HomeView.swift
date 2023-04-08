//
//  HomeView.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import SwiftUI

struct HomeView: View {
    
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
                
                HStack {
                    TextField("Write here", text: $text)
                        .padding(.leading)
                        .frame(maxHeight: .infinity)
                        .background(Color.secondary)
                        .cornerRadius(20)
                    Button {
                        Task {
                            await start()
                        }
                    } label: {
                        Image(systemName: "paperplane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.secondary)
                    
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom)

            }
            .navigationTitle("ChatGPT")
        }
    }
    
    func start() async {
        messages.append("Me: \n\(text)")
        Task {
            if let result = await vm.send(text: text) {
                await MainActor.run {
                    messages.append("ChatGPT: \n\(result.choices.last?.message.content ?? "Error")")
                }
            }
        }
        text = ""
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ChatGPTMobileViewModel())
    }
}
