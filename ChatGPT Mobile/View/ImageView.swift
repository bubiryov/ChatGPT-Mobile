//
//  ImageView.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 08.04.2023.
//

import SwiftUI
import OpenAI

struct ImageView: View {
    @EnvironmentObject var vm: ChatGPTMobileViewModel
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                if !vm.imageIsLoading {
                    if let image = vm.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .padding()
                            .contextMenu {
                                Button {
                                    let saver = ImageSaver()
                                    saver.writeToPhotoAlbum(image: image)
                                } label: {
                                    HStack {
                                        Text("Save")
                                        Image(systemName: "square.and.arrow.down")
                                    }
                                }
                            }
                        
                    }
                } else {
                    LottieView()
                        .frame(width: 200, height: 200)
                }
                
                Spacer()
                RequestField(text: $description, isLoading: vm.imageIsLoading, start: { _ in
                    let temporaryDescription = description
                    description = ""
                    await vm.getImage(prompt: temporaryDescription)
                })
            }
            .navigationTitle("Images")
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
            .environmentObject(ChatGPTMobileViewModel())
    }
}
