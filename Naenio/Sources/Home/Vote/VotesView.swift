//
//  VoteView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/06.
//

import SwiftUI

struct VotesView: View {
    @ObservedObject var viewModel = VotesViewModel()
    @Binding var post: Post
    @State var lastChoice: Int?
    
    var body: some View {
        ZStack {
            if viewModel.status == .inProgress {
                ProgressView()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .zIndex(1)
            }
            
            VStack(spacing: 18) {
                VoteButton(type: .choiceA,
                           isOpened: self.isVoteOpened,
                           choice: self.choiceA,
                           percent: getPercentage(ofSequence: 0), action: {
                    lastChoice = 0
                    viewModel.requestVote(postId: post.id, choiceId: choiceA?.id)
                })
                
                VoteButton(type: .choiceB,
                           isOpened: self.isVoteOpened,
                           choice: self.choiceB,
                           percent: getPercentage(ofSequence: 1),
                           action: {
                    lastChoice = 1
                    viewModel.requestVote(postId: post.id, choiceId: choiceB?.id)
                })
            }
            .onChange(of: viewModel.status) { status in
                switch status {
                case .done:
                    DispatchQueue.main.async {
                        vote(sequence: lastChoice)
                        viewModel.status = .waiting
                    }
                case .fail(with: let error):
                    NotificationCenter.default.postToastAlertWithErrorNotification()
                default:
                    break
                }
            }
            
            Image("vsIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34)
        }
    }
    
    init(post: Binding<Post>) {
        self._post = post
    }
}

extension VotesView {
    var choiceA: Choice? {
        return self.post.choices.first {
            $0.sequence == 0
        }
    }
    
    var choiceB: Choice? {
        return self.post.choices.first {
            $0.sequence == 1
        }
    }
    
    /// 사용자가 투표에 참여해 결과를 공개해야하는지 계산한다
    private var isVoteOpened: Bool {
        return !self.post.choices
            .filter { $0.isVoted }
            .isEmpty
    }
    
    /// 각 보트의 퍼센트를 계산해서 내려준다
    private func getPercentage(ofSequence sequence: Int) -> Double? {
        guard let first = choiceA, let second = choiceB else {
            return nil
        }
        
        let numerator = sequence == 0 ? Double(first.voteCount) : Double(second.voteCount)
        let denominator = Double(first.voteCount + second.voteCount)
        
        if denominator == 0 {
            return 0
        } else {
            return (numerator / denominator) * 100
        }
    }
    
    /// 투표수, 투표 유무를 변경
    ///
    /// Binding을 바로 건드려서 고쳐버린다
    private func vote(sequence: Int?) {
        guard let sequence = sequence,
              var targetChoice = sequence == 0 ? choiceA : choiceB,
              var otherChoice = sequence == 0 ? choiceB : choiceA
        else {
            return
        }
        
        // 처음 투표신가요?
        if !(targetChoice.isVoted || otherChoice.isVoted) {
            post.voteCount += 1
        }
        
        if targetChoice.isVoted { // 재투표 금지
            return
        }
        
        targetChoice.isVoted = true
        targetChoice.voteCount += 1
        
        if otherChoice.isVoted { // 다른 투표가 되어있다면
            otherChoice.isVoted = false
            otherChoice.voteCount -= 1
        }
        
        print(post)
        
        if post.choices[0].id == targetChoice.id {
            post.choices[0] = targetChoice
            post.choices[1] = otherChoice
        } else {
            post.choices[1] = otherChoice
            post.choices[0] = targetChoice
        }
    }
}
