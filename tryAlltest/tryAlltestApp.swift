//
//  tryAlltestApp.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 09.10.2023.
//


//import SwiftUI
//
//enum Route: Hashable {
//    case first
//    case second
//    case third
//}
//
//class Coordinator: ObservableObject {
//    @Published var route: [Route] = []
//}
//
//@main
//
//struct tryAlltest: App {
//    @Environment(\.scenePhase) var scenePhase
//    @StateObject var coordinator = Coordinator()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(coordinator)
//        }
//        .onChange(of: scenePhase) { phase in
//            switch  phase {
//            case .active:
//                print("act")
//            case .background:
//                print("back")
//            case .inactive:
//                print("inact")
//            }
//        }
//    }
//}
//
//
//struct WaterMarkModifier: ViewModifier {
//    var mark: String
//    func body(content: Content) -> some View {
//        content.overlay(alignment: .bottomTrailing) {
//            Text(mark).font(.system(size: 30)).bold().opacity(0.7)
//        }
//    }
//}
//
//extension View {
//    func addWatermark(mark: String) -> some View {
//        self.modifier(WaterMarkModifier(mark: mark))
//    }
//}

//
//import SwiftUI
//
//
//enum Route: Hashable {
//    case first
//    case second
//    case third
//}
//
//class Coordinator: ObservableObject {
//    @Published var route: [Route] = []
//}
//
//@main
//
//struct tryAlltestApp: App {
//    @StateObject private var coordinator = Coordinator()
//    @Environment(\.scenePhase) private var scenePhase
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(coordinator)
//        }
//        .onChange(of: scenePhase) { phase in
//            switch phase {
//            case .active:
//                print()
//            case .background:
//                print()
//            case .inactive:
//                print()
//            default:
//                print()
//            }
//        }
//
//    }
//}
//
//
//struct WaterMarkModifier: ViewModifier {
//    var mark: String
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay( alignment: .bottomTrailing) {
//                Text(mark).font(.system(size: 26)).bold().opacity(0.7)
//            }
//    }
//}
//
//extension View {
//    func addWaterMark(mark: String) -> some View {
//        self.modifier(WaterMarkModifier(mark: mark))
//    }
//}
import SwiftUI

/// просто демо як працюівати за environment та  environmentObject
///
class Model1EnvironmentTest: ObservableObject {
    @Published  var value = "defVal"
}

extension EnvironmentValues {
    var boolValue: Bool {
        set {self[BoolValue.self] = newValue}
        get {self[BoolValue.self]}
    }
}

struct BoolValue: EnvironmentKey {
    static var defaultValue = false
}

/// -----------

enum Route: String, Hashable {
    case first = "first"
    case first1 = "first1"
    case second = "second"
    case third = "third"
    case errorproc = "errorproc"
    case operators = "operators"
    case intersect = "intersection of rectangles"
    case chessboard = "ChessBoard"
    case search = "Search"
    case examples = "Examples"
    case actorsclass = "Actors and Class"
}

class Coordinator: ObservableObject {
    @Published var route: [Route] = []
}


@main

struct tryAlltestApp: App {
    
    
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) var appDelegate
    
    @Environment(\.boolValue) var boolVal
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Model1EnvironmentTest()) //  це таксамо допусається
                .environmentObject(coordinator) /// встановлюємо новае значення  для подальшого використання, по суті ц депенденсі інджекшин
                .environment(\.boolValue, true) /// встановлюємо новае значення  для подальшого використання
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print()
            case .background:
                print()
            case .inactive:
                print()
            default:
                print()
            }
        }
    }
}

struct WaterMarkModifier: ViewModifier {
    var mark: String
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                Text(mark).font(.system(size: 20)).bold().opacity(0.5)
            }
    }
}

extension View {
    func addWatermark(mark: String) -> some View {
        self.modifier(WaterMarkModifier(mark: mark))
    }
}
