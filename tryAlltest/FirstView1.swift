//
//  FirstView1.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 27.10.2023.
//
import SwiftUI

struct FirstView1: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coordinator: Coordinator
    @State private var alowAnimationFlag = false
    @State private var stepAnimationFlag = false
    @State private var layoutFlag = false
    @State private var transitionFlag = false
    @State private var timer = Timer.publish(every: 1, on: .current , in: .common ).autoconnect()
    
    var body: some View {
        VStack {
            VStack {
                if transitionFlag {
                    Group {
                        let layout = AnyLayout(layoutFlag ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout()))
                        layout {
                            ForEach(1...5, id: \.self) { index in
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .offset(x: ( layoutFlag ? (stepAnimationFlag ? 20 : 0) : 0), y: layoutFlag ? 0 :(stepAnimationFlag ? 20 : 0) )
                                    .animation(
                                        .interpolatingSpring(stiffness: 100, damping: 4).delay(Double(index) * 0.1)
                                        ,value: stepAnimationFlag
                                    )
                            }
                            
                        }
                    }
                    //.transition(.move(edge: .leading))
                    .transition(.opacity)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background {
                        Color.teal.opacity(0.3)
                            .ignoresSafeArea()
                    }
                }


                HStack {
                    Button("Transition") { withAnimation(.easeInOut(duration:0.4)) {transitionFlag.toggle() }}
                    if transitionFlag {
                        HStack {
                            Button("Stop/Start") { alowAnimationFlag.toggle() }.padding()
                            Button("Layout") { layoutFlag.toggle() }.padding()
                        }
                        //.transition(.move(edge: .trailing))
                        .transition(.slide )
                    }
                    
                }
                .frame(height: 50)
            }
            .foregroundColor(.cyan)
            .frame(maxWidth: .infinity, maxHeight: 200)

        }
        .onReceive(timer) { _ in
            if alowAnimationFlag {
                stepAnimationFlag.toggle()
            }
        }
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: { dismiss() },
                    label: {
                        Image(systemName: "arrow.left" )
                    }
                )
            }
        }

    }
}
