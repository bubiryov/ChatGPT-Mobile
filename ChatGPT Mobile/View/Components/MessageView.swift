//
//  MessageView.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 09.04.2023.
//

import SwiftUI
import OpenAI

struct MessageView: View {
    
//    var message: Any
    var message: Chat
    
    var body: some View {
//        if let message = self.message as? ChatQuery {
//            let text = message.messages.last?.content ?? "Возникла какая-то ошибка"
//            VStack {
//                Text(text)
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 15)
//                    .foregroundColor(.white)
//                    .font(.system(size: 18))
//                    .background(Color.blue)
//                    .cornerRadius(30)
//                    .frame(maxWidth: 280, alignment: .trailing)
//            }
//            .frame(maxWidth: .infinity, alignment: .trailing)
//
//        } else if let response = self.message as? ChatResult {
//            let text = response.choices[0].message.content
//            VStack {
//                Text(text)
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 10)
//                    .foregroundColor(.primary)
//                    .font(.system(size: 18))
//                    .background(Color.gray.opacity(0.5))
//                    .cornerRadius(20)
//                    .frame(maxWidth: 280, alignment: .leading)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
        
        if message.role == "user" {
            VStack {
                Text(message.content)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .background(Color.blue)
                    .cornerRadius(30)
                    .frame(maxWidth: 280, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        } else {
            VStack {
                Text(message.content)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .foregroundColor(.primary)
                    .font(.system(size: 18))
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(20)
                    .frame(maxWidth: 280, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
//        MessageView(message: ChatQuery(model: .gpt3_5Turbo0301, messages: [.init(role: "user", content: "Какой расход топлива у самой новой Bentley Continental GT?")]))
        MessageView(message: Chat(role: .assistant, content: "Hello"))
    }
}
