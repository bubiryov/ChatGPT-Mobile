//
//  ChatGPT_Mobile_Tests.swift
//  ChatGPT Mobile_Tests
//
//  Created by Egor Bubiryov on 13.04.2023.
//

import XCTest

@testable import ChatGPT_Mobile

class ChatGPTMobileViewModelTests: XCTestCase {
    
    var vm = ChatGPTMobileViewModel(loader: Downloader())
        
//    override func setUp() {
//        super.setUp()
//        viewModel = ChatGPTMobileViewModel(loader: MockDownloader())
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        super.tearDown()
//    }
    
    func testSendWithEmptyText() async {
        // Given
        let initialChatsCount = vm.chats.count
        let initialAllMessagesCount = vm.allMessages.count
        
        // When
        await vm.send(text: "")
        
        // Then
        XCTAssertEqual(vm.chats.count, initialChatsCount)
        XCTAssertEqual(vm.allMessages.count, initialAllMessagesCount)
        XCTAssertFalse(vm.chatIsLoading)
    }
    
    func testSendWithNonEmptyText() async throws {
        // Given
        let initialChatsCount = vm.chats.count
        let initialAllMessagesCount = vm.allMessages.count
        
        // When
        await vm.send(text: "Hello!")
        
        // Then
        XCTAssertEqual(vm.chats.count, initialChatsCount + 2)
        XCTAssertEqual(vm.allMessages.count, initialAllMessagesCount + 2)
        XCTAssertFalse(vm.chatIsLoading)
    }
    
    func testGetImageWithEmptyPrompt() async {
        // Given
        let initialImage = vm.image
        
        // When
        await vm.getImage(prompt: "")
        
        // Then
        XCTAssertEqual(vm.image, initialImage)
        XCTAssertFalse(vm.imageIsLoading)
    }
    
    func testGetImageWithNonEmptyPrompt() async throws {
        // Given
        let initialImage = vm.image
        
        // When
        await vm.getImage(prompt: "Cat")
        
        // Then
        XCTAssertNotNil(vm.image)
        XCTAssertNotEqual(vm.image, initialImage)
        XCTAssertFalse(vm.imageIsLoading)
    }
}

class MockDownloader: Downloader {
    override func downloadImage(url: URL) async throws -> UIImage? {
        return UIImage(systemName: "photo")
    }
}

