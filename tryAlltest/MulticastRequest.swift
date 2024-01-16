//
//  MulticastRequest.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 28.12.2023.
//

import SwiftUI
import Combine


// "Multicast" request

// ідеяв тому, щоби мати можливість налаштувати декльіка підписок, і тільки після цьго запустити піблішер
//example(of: "Multicast") {
    
class MulticastReq {
    
    func exampl() {
        let url = URL(string: "https://www.google.com")!
        
        // Create the ConnectablePublisher using a PassthroughSubject
        let publisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .multicast { PassthroughSubject<Data, URLError>() }
        
        // Create subscriptions
        let subscription1 = publisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("First sink has reported an error: \(error)")
                }
            }, receiveValue: { obj in
                print("First sink retrieved object \(obj)")
            })
        
        let subscription2 = publisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Second sink has reported an error: \(error)")
                }
            }, receiveValue: { obj in
                print("Second sink retrieved object \(obj)")
            })
        
        // Connect the publisher
        let subscription = publisher.connect()
    }
}


