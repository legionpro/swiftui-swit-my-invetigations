//
//  ContentView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 09.10.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var layoutFlag = false
    @State private var allowFlag = false
    @State private var animationFlag = false
    @State private var timer = Timer.publish(every: 1.5, on: .current, in: .common).autoconnect()
    @State private var taskGroupResult = ""
    @State private var processingFlag = false
    
    var body: some View {
        NavigationStack(path: $coordinator.route) {
            VStack {
                Form {
                    Section("task group resul") {
                        Text(taskGroupResult)
                    }
                    Button(
                        action: {
                            processingFlag = true
                            Task {
                                let val = await startTaskGroup()
                                await MainActor.run {
                                    taskGroupResult = val
                                }
                                processingFlag = false
                            }
                        },
                        label: {
                            ZStack {
                                Text("start task group").font(.system(size: 25)).opacity( processingFlag ? 0.4 : 1.0)
                                if processingFlag {
                                    ProgressView()
                                }
                            }
                        }
                    )
                    .disabled(processingFlag)
                }
                VStack{
                    Section("animation") {
                        let layout: AnyLayout = AnyLayout(layoutFlag ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout()))
                        layout {
                            ForEach(1...5, id: \.self) { index in
                                Circle()
                                    .foregroundColor( .pink )
                                    .offset(x: layoutFlag ? 0 : (animationFlag ? 0 : 50), y: layoutFlag ? (animationFlag ? 0 : 50) : 0)
                                    .animation(
                                        .interpolatingSpring(stiffness: 100, damping: 4).delay(Double(index) * 0.1)
                                        , value: animationFlag)
                                
                            }
                        }.frame(width: 300, height: 200)
                        HStack{
                            Button(
                                action: { layoutFlag.toggle()},
                                label: {Text("Change layout")})
                            Button("Allow animation", action: { allowFlag.toggle() })
                        }.buttonStyle(.bordered)
                    }
                    Divider().frame(height: 30)
                    Section("Navigation"){
                        HStack{
                            Button("First", action: {coordinator.route.append(.first)})
                            Button("Second", action: {coordinator.route.append(.second)})
                            Button("Third", action: {coordinator.route.append(.third)})
                            Button("Erroproc", action: {coordinator.route.append(.errorproc)})
                        }
                        HStack{
                            Button("Intersect", action: {coordinator.route.append(.intersect)})
                            Button("ChessBoard", action: {coordinator.route.append(.chessboard)})
                            Button("Search", action: {coordinator.route.append(.search)})
                        }
                        HStack{
                            Button("Examples", action: {coordinator.route.append(.examples)})
                            Button("Actors", action: {coordinator.route.append(.actorsclass)})
                                

                        }
                    }.buttonStyle(.bordered)

                    
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .first:
                        FirstView()
                    case .first1:
                        FirstView1()
                    case .second:
                        SecondView()
                    case .third:
                        ThirdView()
                    case .errorproc:
                        ErrorPrcessing()
                    case .operators:
                        OperatorsView()
                    case .intersect:
                        RectItersect()
                    case .chessboard:
                        ChessBoard()
                    case .search:
                        SearchView()
                    case .examples:
                        ExamplesView()
                    case .actorsclass:
                        ActorsClassExampl()
                    }
                    
                }
            }
        }
        .onReceive(timer) { _ in
            if allowFlag {
                animationFlag.toggle()
            }
        }
    }
    
    
    func startTaskGroup() async -> String {
        var result: [String] = []
        
        let _ = await withTaskGroup(of: String.self) { group in
            
            for i in 1...5 {
                group.addTask(operation: {
                    try? await Task.sleep(for: .seconds(3))
                    var jj = 0
                    for ii in 1...10000 {
                        jj += 1
                    }
                    return "\(i)-ok; "
                })
            }
            
            for await item in group {
                result.append(item)
            }
        }
        return result.reduce(""){return $0 + String($1)}
    }
}
