//
//  VoteView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/06.
//

import SwiftUI

struct VotesView: View {
    @ObservedObject var viewModel: VotesViewModel
    @EnvironmentObject var sourceObject: HomeViewModel
    
    let index: Int
    let choices: [Post.Choice]
    var isOpened: Bool {
        return !choices
            .filter { $0.isVoted }
            .isEmpty
    }
    
    func percentage(ofSequence sequence: Int, source: [Post.Choice]) -> Double? {
        let first = source.first
        let second = source.last
        
        guard let first = first, let second = second else {
            return nil
        }
        
        let numerator = sequence == 0 ? Double(first.voteCount) : Double(second.voteCount)
        let denominator = Double(first.voteCount + second.voteCount)
        
        return (numerator / denominator) * 100
    }

    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                VoteButton(type: .choiceA, isOpened: self.isOpened, choice: choices.first, percent: percentage(ofSequence: 0, source: self.choices)) {
                    DispatchQueue.main.async {
//                        withAnimation(.easeInOut(duration: 0.2)) {
                            sourceObject.vote(index: self.index, sequence: 0)
//                        }
                    }
                }
                
                VoteButton(type: .choiceB, isOpened: self.isOpened, choice: choices.last, percent: percentage(ofSequence: 1, source: self.choices)) {
                    DispatchQueue.main.async {
//                        withAnimation(.easeInOut(duration: 0.2)) {
                            sourceObject.vote(index: self.index, sequence: 1)
//                        }
                    }
                }
            }
            
            Text("VS")
                .font(.engSemiBold(size: 16)) // ???: 제플린 따라서 18로 넣으면 잘 안맞음(https://zpl.io/dxjxvn7)
                .background(
                    Circle().fill(Color.white)
                        .frame(width: 34, height: 34)
                )
        }
    }
    
    init(index: Int, choices: [Post.Choice]) {
        self.index = index
        self.choices = choices
        self.viewModel = VotesViewModel()
    }
}