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
    }
}
