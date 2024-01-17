//
//  GetAsync.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 17.01.2024.
//

import SwiftUI
extension URLSession {
    static let noCacheSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()
}

struct RemoteFile<T: Decodable> {
    let url: URL
    let type: T.Type

    var contents: T {
        get async throws {
            let (data, _) = try await URLSession.noCacheSession.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

struct MessageC: Decodable, Identifiable {
    let id: Int
    let user: String
    let text: String
}

struct GetAsyncView: View {
    let source = RemoteFile(url: URL(string: "https://hws.dev/inbox.json")!, type: [MessageC].self)
    @State private var messages: [MessageC] = []

    var body: some View {
        NavigationView {
            List(messages) { message in
                VStack(alignment: .leading) {
                    Text(message.user)
                        .font(.headline)
                    Text(message.text)
                }
            }
            .navigationTitle("Inbox")
            .toolbar {
                Button(action: refresh) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .onAppear(perform: refresh)
        }
    }

    func refresh() {
        Task {
            do {
                messages = try await source.contents
            } catch {
                print("Message update failed.")
            }
        }
    }
}
