//
//  CarrouselView.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 06.02.2024.
//

import SwiftUI


final class ColorViewModel: ObservableObject {
    @Published var selectedImage1 = ""
    @Published var selectedImage2 = ""
    
    let imageNames = ["star", "trash", "paperplane.fill", "books.vertical", "eraser.line.dashed.fill"]
    
    init() {
        selectedImage1 = imageNames.first ?? "star"
        selectedImage2 = imageNames.first ?? "star"
    }
    
    func nextSelectImage1() {
        guard let currentIndex = imageNames.firstIndex(of: selectedImage1) else {
            return
        }
        
        let nextIndex = currentIndex + 1 < imageNames.count ? currentIndex + 1 : 0
        
        withAnimation {
            selectedImage1 = imageNames[nextIndex]
        }
    }
    
    func nextSelectImage2() {
        guard let currentIndex = imageNames.firstIndex(of: selectedImage2) else {
            return
        }
        
        let nextIndex = currentIndex + 1 < imageNames.count ? currentIndex + 1 : 0
        
        withAnimation {
            selectedImage2 = imageNames[nextIndex]
        }
    }
}

struct CarrouselView: View {
    
    @StateObject var colorViewModel = ColorViewModel()
    
    var body: some View {
        VStack {
            Group {
                Text("with animation")
                VStack {
                    TabView(selection: $colorViewModel.selectedImage1) {
                        ForEach(colorViewModel.imageNames, id: \.description) { imageName in
                            Image(systemName: imageName)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .ignoresSafeArea()
                        }
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                    
                    Button("Next Image") {
                        colorViewModel.nextSelectImage1()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Form {
                Text("with transition")

                VStack {
                    ForEach(colorViewModel.imageNames, id: \.description) { imageName in
                        if imageName == colorViewModel.selectedImage2 {
                            Image(systemName: imageName)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .ignoresSafeArea()
                                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                        }
                    }
                    
                    Button("Next Image") {
                        colorViewModel.nextSelectImage2()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
