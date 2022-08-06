//
//  VoteView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/06.
//

import SwiftUI

struct VotesView: View {
    @ObservedObject var viewModel: VotesViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                VoteButton(type: .A, choice: viewModel.choices[0])
                
                VoteButton(type: .B, choice: viewModel.choices[1])
            }
            
            Text("VS")
                .font(.engSemiBold(size: 16)) // ???: 제플린 따라서 18로 넣으면 잘 안맞음(https://zpl.io/dxjxvn7)
                .background(
                    Circle().fill(Color.white)
                        .frame(width: 34, height: 34)
                )
        }
    }
}

//struct VoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        VotesView(viewModel: <#T##VotesViewModel#>)
//    }
//}
