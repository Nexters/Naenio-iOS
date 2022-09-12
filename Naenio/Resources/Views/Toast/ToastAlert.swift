//
//  Toast.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct ToastAlert: View {
    @Binding var isPresented: Bool
    
    let title: String

    var body: some View {
        ZStack {
            if isPresented {
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 62)
                        .font(.semoBold(size: 18))
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.angularGradient,
                                        style: StrokeStyle(lineWidth: 1,
                                                           lineCap: .round,
                                                           lineJoin: .round)
                                       )
                        )
                }
                .padding(.horizontal, 20)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.interactiveSpring(), value: isPresented)
    }
    
    init(isPresented: Binding<Bool>,
         title: String) {
        self._isPresented = isPresented
        self.title = title
    }
}
