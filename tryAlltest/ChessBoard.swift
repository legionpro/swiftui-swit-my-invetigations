//
//  ChessBoard.swift
//  tryAlltest
//
//  Created by Oleh Poremskyy on 01.11.2023.
//


import SwiftUI

private let count: Int = 8
private var cicleCount: Int = 0

struct ChessBoard: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: Coordinator
    private var bColor = Color.brown
    private var wColor = Color.yellow
    private let size: CGFloat = 60
    @State private var startI = 0
    @State private var startJ = 0

    @State private var processingFlag = false
    @State private var scanResult = ""
    
    private let spacing: CGFloat = 2.0
    @State var board = Array(repeating: Array(repeating: 0, count: 8), count: 8)
    @State private var flag = false
    var body: some View {
        VStack {
            VStack(spacing: self.spacing) {
                ForEach(0..<count, id: \.self) { rindex in
                    HStack(spacing: self.spacing) {
                        ForEach(0..<count, id: \.self) { cindex in
                            ZStack {
                                Rectangle()
                                    .fill(checkColor(i: rindex, j: cindex))
                                    .frame(width: 40, height: 40)
                                    .onTapGesture { getCell(rindex, cindex) }
                                if board[rindex][cindex] == 1 {
                                    Image("knight_small")
                                }
                            }
                        }
                    }
                }
            }.padding()

            Section("Press to find the way to fill the board") {
                Button(
                    action: {
                        processingFlag = true
                        Task {
                            await scanBoard()
                            await MainActor.run {
                                processingFlag = false
                            }
                        }
                    },
                    label: {
                        ZStack {
                            Image(systemName: "arrow.right").opacity(processingFlag ? 0.4 : 1.0)
                            if processingFlag {
                                ProgressView()
                            }
                        }
                    }
                )
                .buttonStyle(.bordered)
                .disabled(processingFlag)
                Text(String(scanResult))
                Divider()
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
    
    func getCell(_ row: Int, _ column: Int) {
        board[row][column] = board[row][column] == 0 ? 1 : 0
    }
    
    func checkColor(i: Int, j: Int) -> Color {
        var result = self.bColor
        if (i + j % 2) % 2 == 0 {
            result = self.wColor
        }
        
        return result
    }
    func scanBoard() async {
        var arr = [(i: Int, j: Int)]()
        for ii in 0..<8 {
            for jj in 0..<8 {
//                print("---\(ii) \(jj)")
                var path = ""
                cleanBoard()
                let res = await getNextStep(curerntI: ii, currentJ: jj)
                if chekRes() {
                    arr.append((i: ii, j: jj))
                    let str = "\(arr)"
                    cicleCount += 1
                    print("result \(cicleCount);  path: \(res)")
                    await MainActor.run {
                        scanResult = str
                    }
                }
            }
        }
        print("the result: \(arr)")

    }
    

    
    func getNextStep(curerntI: Int, currentJ: Int) async -> String {
        let i1: Int? = curerntI + 1 < board.count ? curerntI + 1  : nil
        let i1_: Int?  = curerntI - 1 >= 0 ? curerntI - 1 : nil
        let i2: Int? = curerntI + 2 < board.count ? curerntI + 2  : nil
        let i2_: Int?  = curerntI - 2 >= 0 ? curerntI - 2 : nil
        let j1_: Int?  = currentJ - 1 >= 0 ? currentJ - 1 : nil
        let j1: Int?  = currentJ + 1 < board.count ? currentJ + 1 : nil
        let j2_: Int?  = currentJ - 2 >= 0 ? currentJ - 2 : nil
        let j2: Int?  = currentJ + 2 < board.count ? currentJ + 2 : nil
        
        let arr: [(ii: Int?, jj: Int?)] = [(ii: i2_, jj: j1_),(ii: i2_,jj: j1),(ii: i2,jj: j1_),(ii: i2,jj: j1),
                                           (ii: i1_,jj: j2_),(ii: i1_,jj: j2),(ii: i1,jj: j2_),(ii: i1,jj: j2)]
        await putKnigtTo(curerntI,currentJ)
        var result = "; \(curerntI)-\(currentJ)"

        try? await Task.sleep(for: .seconds(0.05))
        for item in arr {
            if let ii = item.ii, let jj = item.jj {
                if board[ii][jj] == 0 {
                    result += await getNextStep(curerntI: ii, currentJ: jj)
                    if chekRes() {
                        break
                    }
                }
            }
        }
        return result
    }
    
    func chekRes() -> Bool {
        var result = true
        if board.joined().contains(0) {
            result = false
        }
        return result
    }
    
    @MainActor
    func putKnigtTo(_ ii: Int, _ jj: Int){
        board[ii][jj] = 1
    }
    
    func cleanBoard() {
        for ii in 0..<8 {
            for jj in 0..<8 {
                board[ii][jj] = 0
            }
        }
    }
}

