//
//  NewToastAlertView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/09/21.
//

import SwiftUI

struct ToastAlertView<T, Information>: View where T: ToastContainerType, Information: ToastInformationType {
    @Binding var isPresented: Bool
    let informations: [Information]
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        ForEach(informations, id: \.title) { info in
                            Button(action: {
                                info.action()
                                isPresented = false
                            }) {
                                Text(info.title)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .frame(height: 62)
                                    .font(.semoBold(size: 16))
                                    .foregroundColor(.warningRed)
                            }
                            
                            
                            if info.title != informations.last?.title {
                                CustomDivider()
                                    .fillHorizontal()
                            }
                        }
                    }
                    .background(Color.card)
                    .cornerRadius(10)
                }
                    
                .transition(.move(edge: .bottom))
                .padding(.horizontal, 20)
            }
        }
        .animation(.interactiveSpring(), value: isPresented)
    }
    
    init(_ container: Binding<T>) {
        self._isPresented = container.isPresented
        self.informations = container.informations.wrappedValue as! [Information]
    }
}
