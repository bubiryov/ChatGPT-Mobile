//
//  ImageSaver.swift
//  ChatGPT Mobile
//
//  Created by Egor Bubiryov on 10.04.2023.
//

import Foundation
import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
}
