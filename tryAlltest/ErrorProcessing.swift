//
//  ErrorProcessing.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 17.10.2023.
//

import SwiftUI
import Combine

let practicalCombine = URL(string: "https://practicalcombine.com")!
let donnywals = URL(string: "https://donnywals.com")!

var cancellables = Set<AnyCancellable>()

enum ErrorMes: Error {
  case failed
}

struct ErrorPrcessing: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var sendval: Int = 0
    @State private var model = ErrorProcessingModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Form {
            Section("subject with error replace") {
                Button("send next", action: { model.subject.send(sendval); sendval += 1 })
                Button("send completion", action: { model.subject.send(completion: .failure(ErrorMes.failed))})
            }
        }
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {dismiss()},
                    label: { Image(systemName: "arrow.left") }
                )
            }
        }
    }
    
    func example() {
        URLSession.shared.dataTaskPublisher(for: practicalCombine)
          .catch({ urlError in
            return URLSession.shared.dataTaskPublisher(for: donnywals)
          })
          .sink(receiveCompletion: { completion in
          }, receiveValue: { value in
          })
          .store(in: &cancellables)
    }
    
}





class ErrorProcessingModel: ObservableObject {
    var subject = PassthroughSubject<Int, Error>()

    init() {
        subject
            .replaceError(with: 42)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { int in
                print(int)
            })
            .store(in: &cancellables)
    }
    
    func checkUserName(userName: String)
        -> AnyPublisher<Bool, Never> {
      guard let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
        return Just(false).eraseToAnyPublisher()
      }
      
      return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
        .map(\.isAvailable)
        .replaceError(with: false)
        .eraseToAnyPublisher()
    }
}


struct UserNameAvailableMessage: Decodable {
    let isAvailable: Bool
}

enum APIError: LocalizedError {
  /// Invalid request, e.g. invalid URL
  case invalidRequestError(String)
}

struct AuthenticationService {
  
  func checkUserNameAvailablePublisher(userName: String)
      -> AnyPublisher<Bool, Error> {
    guard let url =
        URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
      return Fail(error: APIError.invalidRequestError("URL invalid"))
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
      .map(\.isAvailable)
//      .replaceError(with: false)
      .eraseToAnyPublisher()
  }
  
}

