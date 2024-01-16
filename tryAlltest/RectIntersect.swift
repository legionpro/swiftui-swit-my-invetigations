//
//  RectIntersect.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 31.10.2023.
//

import SwiftUI
import Combine

class Model1: ObservableObject {
    var bag = Set<AnyCancellable>()
    var aX: CGFloat = 80
    var aY: CGFloat = 100
    
    var widthA: CGFloat = 150
    var heightA: CGFloat = 120
    var widthB: CGFloat = 150
    var heightB: CGFloat = 100
    
    var bX: CGFloat = 100
    var bY: CGFloat = 300
    @Published var location1 = CGPoint(x: 80, y: 100)
    @Published var location2 = CGPoint(x: 100, y: 100)
    
    func func1() -> String {
        return ""
    }
    
    func getLeftRect( rectA: CGRect, rectB: CGRect) -> (CGRect, CGRect) {
        return rectA.minX < rectB.minX ? (rectA, rectB) : (rectB,rectA)
    }
    
    func getTopRect( rectA: CGRect, rectB: CGRect) -> (CGRect, CGRect) {
        return rectA.minY < rectB.minY ? (rectA, rectB) : (rectB,rectA)
    }
    
    func checkInsect( rectA: CGRect, rectB: CGRect) -> CGRect? {
        var result: CGRect? = nil
        let rects0 = getLeftRect( rectA: rectA, rectB: rectB)
        let rects1 = getTopRect( rectA: rectA, rectB: rectB)
        print(rects0)
        print("-----")
        print(rects1)
        if ((rects0.0.minX + rects0.0.width) > rects0.1.minX) && ((rects1.0.minY + rects1.0.height) > rects1.1.minY) {
            result = CGRect(x: rects0.1.minX, y: rects1.1.minY, width: rects0.0.width + rects0.0.minX - rects0.1.minX, height: rects1.0.minY + rects1.0.height - rects1.1.minY)
        }
        return result
    }
    
    
    func getComb( rects: [CGRect]) -> Bool {
        var res = false
        let arr = [rects]
          
        let pub1 = arr.publisher
            .map{ ($0[0].minX < $0[1].minX) ? [$0[0],$0[1]] : [$0[1],$0[0]] }
            .print()
            .map{ ($0[0].minX + $0[0].width) > $0[1].minX}
            .print()
            .eraseToAnyPublisher()
        
        let pub2 = arr.publisher
            .map{ ($0[0].minY < $0[1].minY) ?  [$0[0],$0[1]] : [$0[1],$0[0]] }
            .print()
            .map{ ($0[0].minY + $0[0].height) > $0[1].minY}
            .print()
            .eraseToAnyPublisher()


        Publishers.Merge(pub1, pub2).reduce(true) { $0 && $1}.sink(receiveValue: {val in res = val; print("-=-=- \(res)")}).store(in: &bag)
        return res

        
    }
}
    


struct RectItersect: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject private var model = Model1()
    @State private var res1 = "---"
    @State private var res2 = "---"
    @State private var insect: CGRect? = nil

    var body: some View {
        let rectA =  CGRect(x: model.aX, y: model.aY, width: model.widthA, height: model.heightA)
        let rectB =  CGRect(x: model.bX, y: model.bY, width: model.widthB, height: model.heightB)
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: rectA.width, height: rectA.height)
                    .position(model.location1)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                self.res1 = "---"
                                self.res2 = "---"
                                self.insect = nil
                                withAnimation(.easeInOut,  {
                                    model.location1 = value.location
                                    model.aX = value.location.x - model.widthA/2
                                    model.aY = value.location.y - model.heightA/2
                                })

                            })
                    )

                Rectangle()
                    .fill(Color.yellow)
                    .frame(width:rectB.width, height: rectB.height)
                    .position(model.location2)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                self.res2 = "---"
                                self.res1 = "---"
                                self.insect = nil
                                withAnimation(.easeInOut,  {
                                    model.location2 = value.location
                                    model.bX = value.location.x - model.widthB/2
                                    model.bY = value.location.y - model.heightB/2
                                })

                            })
                    )
                if let insect = self.insect {
                    Rectangle()
                        .stroke(.red, lineWidth: 3.0)
                        .frame(width: insect.width, height: insect.height)
                        .position(x: insect.minX + insect.width/2, y: insect.minY + insect.height/2)
                }
            }.background(Color.gray)

            Form {
                Section("drag the rect and check intersect") {
                    LabeledContent( content: {
                        Button("Check by function", action: {
                            self.insect = model.checkInsect( rectA: rectA, rectB: rectB)
                        }).buttonStyle(.bordered)
                    }, label: {Text(self.insect != nil ? "true" : "false")}
                    )
                    LabeledContent( content: {
                        Button("by combine subsctipt", action: {
                            self.res2 = String(model.getComb( rects: [rectA,rectB]))
                        }).buttonStyle(.bordered)
                    }, label: { Text(self.res2)}
                    )
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        .toolbar{
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: { dismiss() }, label: {Image(systemName: "arrow.left")})
            })
        }
    }
}

//#Preview {
//    ContentView()
//}
