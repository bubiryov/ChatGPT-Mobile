//
//  RequestField.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 09.04.2023.
//

import SwiftUI

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
                .background(Color.secondary.opacity(0.5))
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
                        .bold()
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


struct RequestField_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ChatGPTMobileViewModel()
        RequestField(text: .constant(""), isLoading: false, start: { _ in await vm.getImage(prompt: "") })
            .environmentObject(ChatGPTMobileViewModel())
    }
}
