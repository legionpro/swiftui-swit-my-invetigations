//
//  ActorsClassExampl.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 16.01.2024.
//

import SwiftUI
/// rase conditions  явно проявляється в терміналі
/// декіька раз натискамо кнопку Class - і бачимо, що іноді друкаєтьс два онакових висла
/// для актора такого не  виходить

struct ActorsClassExampl: View {
    @StateObject private var counterModel = CounterModel()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    counterModel.counterIncA()
                }, label: {Text("Actor Conter")})
                Button(action: {
                    counterModel.counterIncC()
                }, label: {Text("Class Conter")})
            }
        }
    }

}

actor ACounter {
    var value = 0

    func increment() -> Int {
        let newValue = value + 1
        value = newValue
        return value
    }
}

class CCounter {
    var value = 0

    func increment() -> Int {
        let newValue = value + 1
        value = newValue
        return value
    }
}

class CounterModel: ObservableObject {
    var value: Int = 0
    var lock = NSLock()
    let semaphore = DispatchSemaphore(value: 1)
    let acounter = ACounter()
    let ccounter = CCounter()
    
    
    func counterIncA() {

        Task.detached {
            await print("10 = ",self.acounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            try! await Task.sleep(for: .seconds(1) )
            await print("11 = ",self.acounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            await print("12 = ",self.acounter.increment()) // data race
        }

        Task.detached {
            await print("20 = ",self.acounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            await print("21 = ",self.acounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            await print("22 = ",self.acounter.increment()) // data race
        }
    }
    
    
    func counterIncC() {

        Task.detached {
            print("10 = ",self.ccounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            print("11 = ",self.ccounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            print("12 = ",self.ccounter.increment()) // data race
        }

        Task.detached {
            print("20 = ",self.ccounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            print("21 = ",self.ccounter.increment()) // data race
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            print("22 = ",self.ccounter.increment()) // data race
        }
    }

}
