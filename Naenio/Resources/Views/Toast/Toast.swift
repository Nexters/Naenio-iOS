//
//  Toast.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct Toast: View {
    @Binding var isPresented: Bool
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    Button(action: {
                        action()
                        isPresented = false
                    }) {
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 62)
                            .font(.semoBold(size: 18))
                            .foregroundColor(.warningRed)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.card)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.interactiveSpring(), value: isPresented)
    }
    
    init(isPresented: Binding<Bool>,
         title: String,
         action: @escaping () -> Void) {
        self._isPresented = isPresented
        self.title = title
        self.action = action
    }
}
