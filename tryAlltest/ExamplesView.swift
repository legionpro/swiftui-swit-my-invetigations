//
//  ExamplesView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 10.01.2024.
//

import SwiftUI

class A {
    init() {
        print(" + ========= base class A init")
    }
    
    deinit {
        print(" - ========= base class A deinit")
    }
}
class Property {
    var value = 0
    init() {
        print(" + Property  init -------")
    }
    
    deinit {
        print(" - Property deinit-------")
    }
}
class B: A {
    var prop = Property()
    
    override init() {
        print(" + MAIN class B init")
    }
    
    deinit {
        print(" - MAIN class B deinit")
    }
}


struct ExamplesView: View {
    
    var body: some View {
        VStack {
            Button(action: {deinitInit()}, label: {Text("init deinit")})
        }
    }
    
    func deinitInit() {
        var bb = B()
        print("class B created \(bb.prop)")
    }
    
}
    
    
    


