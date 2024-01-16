//
//  FuturePromuseModel.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 29.12.2023.
//

import SwiftUI
import Combine


struct ReqModel: Decodable {
    let user = ""
    let name = ""
    
    
    enum ReqEn: Decodable {
        case user, name
        
        
    }
}


class FuturePromuseModel: ObservableObject {
    
    func tesrRE() throws {
        
        func transformA(value: ReqModel) async -> ReqModel {
                try? await Task.sleep(for: .seconds(3))
                return value
        }
        
        
        var box = Set<AnyCancellable>()
        guard let url = URL(string: "https:\\www") else { return }
        
        
        
        let _ = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() {
                guard $0.data.count > 0 else { throw URLError(.zeroByteResource ) }
                return $0.data
            }
            .decode(type: ReqModel.self, decoder: JSONDecoder())
            .tryMap{ value in

                Future<ReqModel, Error> { promise in
                  Task {
                      do {
                          let output = try await transformA(value: value)
                          promise(.success(output))
                      }
                      catch {
                          promise(.failure(error))
                      }
                  }
              }
          }

          .sink(receiveCompletion: { print("completion: \($0)") },
                receiveValue: { print($0) })
          .store(in: &box)
    }
}
