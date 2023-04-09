//
//  MessageView.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 09.04.2023.
//

import SwiftUI
import OpenAI

struct MessageView: View {
    
    var message: Any
    
    var body: some View {
        if let message = self.message as? ChatQuery {
            let text = message.messages[0].content
            VStack {
                Text(text)
                    .padding(10)
                    .foregroundColor(.white)
                    .font(.title3)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .frame(maxWidth: 280, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

        } else if let response = self.message as? ChatResult {
            let text = response.choices[0].message.content
            VStack {
                Text(text)
                    .padding(10)
                    .foregroundColor(.black)
                    .font(.title3)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(15)
                    .frame(maxWidth: 280, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: ChatQuery(model: .gpt3_5Turbo0301, messages: [.init(role: "user", content: "Вы можете добавить модификатор `fixedSize(horizontal: true, vertical: false)` и установить максимальную ширину текста, используя модификатор `.frame(width: 280)`.")]))
    }
}
