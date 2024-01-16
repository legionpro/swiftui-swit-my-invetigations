//
//  OperatorsView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 18.10.2023.
//

import SwiftUI


struct OperatorsView: View {
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        Form {
            Section("filtering") {
                
            }
        }
        .navigationTitle(coordinator.route.last?.rawValue ?? "")
        
    }
}
