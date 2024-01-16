//
//  SearchView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 16.11.2023.
//

import SwiftUI

struct Message: Identifiable, Codable {
    let id: Int
    var user: String
    var text: String
}

enum SearchScope: String, CaseIterable {
    case inbox, favorites
}

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: Coordinator
    @State private var messages = [Message]()
    @State private var searchText = ""
    @State private var searchScope = SearchScope.inbox
    

    
    var body: some View {
            List {
                ForEach(filteredMessages) { message in
                    VStack(alignment: .leading) {
                        Text(message.user).font(.headline)
                        Text(message.text)
                    }
                }
            }
            .navigationTitle("Messageslist")
        .searchable(text: $searchText)
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .toolbar{
            ToolbarItem(placement: .topBarLeading, content: { Button( action: { dismiss() }, label: { Image(systemName: "arrow.left")}) }
            )}
        .onSubmit(of:  .search, runSearch)
        .onChange(of: searchScope) { _ in runSearch()}
    }
    
    
    
    var filteredMessages: [Message] {
        if searchText.isEmpty {
            return messages
        } else {
            return messages.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }


    func runSearch() {
        Task {
            guard let url = URL(string: "https://hws.dev/\(searchScope.rawValue).json") else {return}
            let (data, _) = try await URLSession.shared.data(from:url)
            messages = try JSONDecoder().decode([Message].self, from: data)
            
        }
        
    }
    
}
