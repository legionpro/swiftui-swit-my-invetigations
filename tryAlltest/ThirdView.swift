//
//  ThirdView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 09.10.2023.
//

import SwiftUI
import Combine

let testUrl1 = "https://jsonplaceholder.typicode.com/users"
let testUrl0 = "https://dummyjson.com/products/1"
let testUrl = "https://api.chucknorris.io/jokes/random"

let json = #"""
{
    "categories":[],
    "created_at":"2020-01-0513:42:19.104863",
    "icon_url":"https://assets.chucknorris.host/img/avatar/chuck-norris.png",
    "id":"-ojhx2pdtuygy5wqq-n2lq",
    "updated_at":"2020-01-05 13:42:19.104863",
    "url":"https://api.chucknorris.io/jokes/-ojhx2pdtuygy5wqq-n2lq",
    "value":"Only Chuck Norris can prevent forest fires."
}
"""#

struct JockeJSON: Decodable {
    let value: String
    
    enum CodingKeys : String, CodingKey {
        case value = "value"
    }
}

enum ERR: Error {
    case firstError
}

class LoaderModel: ObservableObject {
    func get1() {
        guard let url = URL(string: testUrl) else {
            //return Just(false).eraseToAnyPublisher()
            return
        }
        let sharedPublisher = URLSession.shared.dataTaskPublisher(for: url).share()
        
        let _ = sharedPublisher.tryMap() {
            guard $0.data.count > 0 else { throw ERR.firstError}
            return $0.data
        }
            .decode(type: JockeJSON.self, decoder: JSONDecoder())
            .receive(on: RunLoop())
            .sink( receiveCompletion: { _ in print()}, receiveValue: { print($0)} )
                    .store(in: )
    }
    

}
                   
                


class ThirdViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
    func getDate() {
        guard let url = URL(string: testUrl) else {
            //return Just(false).eraseToAnyPublisher()
            return
        }
        
        let urlSharedPublisher = URLSession.shared.dataTaskPublisher(for: url).share()
        
        urlSharedPublisher
            .tryMap() {
                guard $0.data.count > 0 else {
                    throw URLError(.zeroByteResource )
                }
                print($0.data)
                return $0.data
            }
            .decode(type: JockeJSON.self, decoder: JSONDecoder())
            //.print("+-+")
            //.output(at: 0)
            //.receive(on: RunLoop())
            .sink( receiveCompletion: {print($0)}, receiveValue: { print($0.value)})
            .store(in: &bag)

        }
}

struct ThirdView: View {
    @State private var model = ThirdViewModel()
    @State private var tokener = ULRSessionTest1()
    @State private var debuger = DebugObserve()
    @EnvironmentObject var coordinator: Coordinator
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            Button("get") { tokener.gettoken() }
            Button("Joke") { model.getDate() }
            Button("Debug") { debuger.testdebug() }
        }
        .buttonStyle(.bordered)
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
             Button(
                action: {
                    dismiss()
                },
                label: {
                    Image(systemName: "arrow.left")
                }
             )
            }
        }
    }
}

extension URLSession {

    enum SessionError: Error {
        case statusCode(HTTPURLResponse)
        case justERR
    }

    func my_dataTaskPublisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {

        return self.dataTaskPublisher(for: url)
            .tryMap(){ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) == false {
                    throw SessionError.statusCode(response)
                }

                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


class ULRSessionTest1: ObservableObject {
    var bag =  Set<AnyCancellable>()
    
    let url1 = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    struct User: Codable {
        let id: Int
        let name, username, email: String
        let address: Address
        let phone, website: String
        let company: Company
    }
    
    struct Address: Codable {
        let street, suite, city, zipcode: String
        let geo: Geo
    }

    struct Geo: Codable {
        let lat, lng: String
    }

    struct Company: Codable {
        let name, catchPhrase, bs: String
    }

    typealias Users = [User]

    
    func gettoken() {
        URLSession.shared.my_dataTaskPublisher(for: url1)
            .print("++++++started\n")
//            .breakpoint(receiveOutput: { (items) -> Bool in
//                return items.count > 1
//            })
//            .catch { error -> Just([String]) in
//                print("Decoding failed with error: \(error)")
//                return Just([])
//            }
            .handleEvents(receiveSubscription: { (subscription) in
                print("Receive subscription")
            }, receiveOutput: { output in
                print("Received output: \(output)")
            }, receiveCompletion: { _ in
                print("Receive completion")
            }, receiveCancel: {
                print("Receive cancel")
            }, receiveRequest: { demand in
                print("Receive request: \(demand)")
            })
            .sink(receiveCompletion: { (completion) in
                print(completion)
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }) { (users: Users) in
                users.forEach({
                    print("\($0.name)")
                })
            }
            .store(in: &bag)
    }
}

class DebugObserve: ObservableObject {
    func testdebug() {
        let squares = [1, 2, 3].publisher
            .print("Squares")
            .map { $0 * $0 }
            .sink { _ in }
    }
    
}

