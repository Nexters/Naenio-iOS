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
            
            VStack(alignment: .center) {
                Spacer()
                
                if isPresented {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 62)
                            .font(.semoBold(size: 16))
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
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 20)
        }
        .animation(.interactiveSpring(), value: isPresented)
    }
    
    init(isPresented: Binding<Bool>,
         title: String) {
        self._isPresented = isPresented
        self.title = title
    }
}
