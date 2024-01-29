//
//  FirstView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 09.10.2023.
//

import SwiftUI
import Combine

class FirstViewModel: ObservableObject {
    @Published var userName = ""
    @Published var password = ""
    @Published var passConfirm = ""
    @Published var validationFlag = false
    
    private var cancelable = Set<AnyCancellable>()
    
    private lazy var userValidator: AnyPublisher<Bool,Never> = {
        $userName
            .map{ $0.count > 3 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var passwordValidator: AnyPublisher<Bool,Never> = {
        Publishers.CombineLatest($password,$passConfirm)
            .map{ $0.count > 5 && ($0 == $1)}
            .eraseToAnyPublisher()
    }()
    
    init() {
        let _ = Publishers.CombineLatest( userValidator, passwordValidator)
            .map{ $0 && $1}
            .assign(to: &$validationFlag)
    }
    
}

class Model: ObservableObject {
    @Published var userName = ""
    @Published var password = ""
    @Published var confirm = ""
    @Published var isValidFlag = false
    
    private lazy var userValidator: AnyPublisher<Bool,Never> = {
        $userName
            .map{ $0.count > 3}
            .eraseToAnyPublisher()
    }()
    
    private lazy var passwordValidator: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($password, $confirm)
            .map { $0.count > 5 && ($0 == $1) }
            .eraseToAnyPublisher()
    }()
    
    init() {
        let _ = Publishers.CombineLatest(userValidator, passwordValidator)
            .map{ $0 && $1}
            .assign(to: &$isValidFlag )
    }
}


struct FirstView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var model = FirstViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var data = ""
    
    var body: some View {
        VStack{
            Form {
                Section{
                    TextField("user name", text: $model.userName)
                    TextField("password", text: $model.password)
                    TextField("confirm", text: $model.passConfirm)
                }
                HStack{
                    Spacer()
                    Button(" LogIn", action: {})
                        .disabled(!model.validationFlag)
                    Spacer()
                }
                Text("observe .task cancelation on disapearing in log")
            }
                Divider()
                Section("more navigation") {
                    Button("go to First1 View", action: {coordinator.route.append(.first1)}).buttonStyle(.bordered)
                }

            
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
                }
        )
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: { dismiss() },
                    label: {
                        Image(systemName: "arrow.left")
                    }
                )
            }
        }
        /// two examples of task with cancelation on disappearing -
        .task {
            //Task { - it is main task and it is canceled but subtassk is not? so "Task {" is non needed
                do {
                    for _ in 1...100000 {
                        try await Task.sleep(for: .seconds(0.1))
                        //await Task.sleep(5_000_000_000) // Sleep for 2 seconds
                        try Task.checkCancellation()
                        data = "Data loaded"
                    }
                } catch {
                    print("Error: \(error)")
                }
            //}
        }
        .task(id:"1") {
            //Task {  - this is turns off cancelation
                await onapp()
            //}
        }
    }
    
    
    func onapp() async {
        do {
            defer { print("defer printing")}
            var counter = 0
            //for item in 1...10 {
                counter += 1
                try await Task.sleep(for: .seconds(10))
                await Task.yield()
                try Task.checkCancellation()
                if Task.isCancelled {
                    print("canceled")
                } else {

                   
                }
            //}
        }
        catch {
            print("catch----")
        }
            
    }
}
