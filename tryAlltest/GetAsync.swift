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
        VStack {
            Button(action: { Task { try! await printUsers() } }, label: {Text("for await")})
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
    
    func printUsers() async throws {
        
        let url = URL(string: "https://hws.dev/users.csv")!

        //.lines does AsyncSequinceProtocol
        for try await line in url.lines {
            let parts = line.split(separator: ",")
            guard parts.count == 4 else { continue }

            guard let id = Int(parts[0]) else { continue }
            let firstName = parts[1]
            let lastName = parts[2]
            let country = parts[3]

            print("Found user #\(id): \(firstName) \(lastName) from \(country)")
        }
    }
}
