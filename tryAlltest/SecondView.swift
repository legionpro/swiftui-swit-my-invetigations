//
//  SecondView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 09.10.2023.
//

import SwiftUI
import Combine

class SecondViewModel: ObservableObject {
    let merge1 = PassthroughSubject<Int,Never>()
    let merge2 = PassthroughSubject<Int,Never>()
    let zip1 = PassthroughSubject<Int,Never>()
    let zip2 = PassthroughSubject<String,Never>()
    let last1 = PassthroughSubject<Int,Never>()
    let last2 = PassthroughSubject<String,Never>()
    
    var mi1 = 0
    var mi2 = 0
    var zi1 = 0
    var zi2 = 0
    var li1 = 0
    var li2 = 0
    
    @Published var resultMI: Int = 0
    @Published var resultZI: (Int,String) = (0,"0")
    @Published var resultLI: (Int,String) = (0,"0")
    
    var bag = Set<AnyCancellable>()
    
    init() {
        Publishers.Zip(zip1,zip2)
            .sink(receiveValue: { [weak self] val in print("zipval = \(val) "); self?.resultZI = val } )
            .store( in: &bag)
        
        Publishers.Merge( merge1, merge2 )
            .sink(receiveValue: {  [weak self]  val in print("merge = \(val)"); self?.resultMI = val })
            .store(in: &bag)
        
        Publishers.CombineLatest(last1, last2)
            .sink(receiveValue: { [weak self]  val in  print("last = \(val)"); self?.resultLI = val })
            .store(in: &bag)
    }
}

enum MyError: Error {
    case err0
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var model = SecondViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    
    var body: some View {
        VStack{
            Form {
                Section {
                    Text(String(model.resultMI))
                    HStack {
                        Button("merge1", action: { model.merge1.send(model.mi1); model.mi1 += 1 })
                        Button("merge2", action: { model.merge2.send(model.mi2); model.mi2 += 2 })
                    }
                }
                Section {
                    let str = String(model.resultZI.0) + "," + model.resultZI.1
                    Text(str)
                    HStack {
                        Button("zip1", action: { model.zip1.send(model.zi1); model.zi1 += 1 })
                        Button("zip2", action: { model.zip2.send(String(model.zi2)); model.zi2 += 1 })
                        //Button("zip1.error", action: {model.zip1.send(completion: .failure(MyError(.err0)))}) - defined as Never
                        Button("zip2.completion", action: {model.zip1.send(completion: .finished)})
                    }
                }
                Section {
                    let str = String(model.resultLI.0) + " " + model.resultLI.1
                    Text(str)
                    HStack {
                        Button("last1", action: { model.last1.send(model.li1); model.li1 += 1})
                        Button("last2", action: { model.last2.send(String(model.li2)); model.li2 += 1 })
                    }
                }
            }
            .buttonStyle(.bordered)
            
        }
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: { dismiss() },
                    label: { Image(systemName: "arrow.left")}
                )
            }
        }
    }
}
//
//class ModelTest: ObservableObject {
//    
//    @Published private var intPublisher: Int = 0
//    
//    private lazy var intPub: AnyPublisher<Int,Never> = {
//        $intPublisher
//            .map{$0 + 2}
//            .eraseToAnyPublisher()
//    }()
//    
//    var intSubject = PassthroughSubject<Int,Never>()
//    var strSubject = PassthroughSubject<String,Never>()
//    
//    var bag = Set<AnyCancellable>()
//    
//    init() {
//        Publishers.Zip(intSubject, strSubject).sink{val in print("\(val)")}.store(in: &bag)
//        
//    }
//    
//
//    
//    func createGroup() async {
//        var res: [String] = []
//        var result = await withTaskGroup(of: String.self) { group in
//    
//            for index in 1...9 {
//                group.addTask(operation: {
//                    var ii = 0
//                    for _ in 1...100000 {
//                        ii += 1
//                    }
//                    if Task.isCancelled {
//                        return "canceled \(index)"
//                    } else {
//                        return String(index)
//                    }
//
//                })
//
//            }
//            for await item in group {
//                res.append(item)
//            }
//            return res
//        }
//    }
//    
//}
