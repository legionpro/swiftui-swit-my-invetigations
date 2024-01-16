//
//  Examles.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 23.11.2023.
//

import SwiftUI
// stored prop in protocol is denied but
//------

class CA {
    var value: Int = 11
    func printCA() {
        print("CA")
    }
}

class CA1: CA {
    
    override func printCA() {
        print("CA1")
    }
    
}

protocol PA: CA {
    
}

extension PA {
    func checkStoredVal() {
        self.value = 0
    }
}

// -------



//----------------------
//just exmapl for enum
enum ASS {
    case AA(ass: String, ai: Int)
    case BB(bs: String, bi: Int)
}

class Temp {
    let avar:ASS = ASS.AA(ass: "11", ai: 11)
    let bvar:ASS = ASS.BB(bs: "12", bi: 12)
    
    init() {
        switch bvar {
        case .AA( ass: let as1, ai: let ai1 ):
            print(as1,ai1)
        case .BB( bs: let bs1, bi: let bi1):
            print(bs1,bi1)
        }
    }
}
//----------------------


@globalActor
public struct TopName{
    public actor MyAct {}
    public static let shared = MyAct()
}

@TopName
struct ForGActorStruct {
    
}

actor Stack<T> {

    
    private var body: Array<T> = []
    
    func  push(_ element: T) {
        body.append(element)
    }
    func pop() -> T? {
        let result = body.last
        body.removeLast()
        return result
    }
}



actor Element1<T> {
    
    private var _val: T
    private var _next: Element1?
    
    public var val: T {
        return self._val
    }
    public var next: Element1? {
        return self._next
    }
    
    
    func setVal(_ element: T) {
        self._val = element
    }
    
    func setNext(_ element: Element1?) {
        self._next = element
    }
    
    init(val: T, next: Element1? = nil) {
        self._val = val
        self._next = next
    }
    

}

actor List1<T> {
    var first: Element1<T>
    var last: Element1<T>

    func appendElemnet(_ val: T) {
//        Task {
//            await self.last.setNext(Element1(val: val))
//            //self.last = await self.last.getNext()!
//        }
    }
    

    

    init(first: Element1<T>, last: Element1<T>? = nil) {
        self.first = first
        if let last = last {
            self.last = last
        }
        else {
            self.last = first
        }
        
    }
}

struct PlayButton: View {
@Binding var isPlaying: Bool


var body: some View {
    Button(isPlaying ? "Pause" : "Play") {
        isPlaying.toggle()
    }
}
}

struct PlayerView: View {
var episode = "EPISOD"
@State private var isPlaying: Bool = false


var body: some View {
    VStack {
        Text(episode)
            .foregroundStyle(isPlaying ? .primary : .secondary)
        PlayButton(isPlaying: $isPlaying) // Pass a binding.
    }
}
}

