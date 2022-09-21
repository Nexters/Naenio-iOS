//
//  NewToastAlertView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/09/21.
//

import SwiftUI

struct NewToastAlertView: View {
    @Binding var isPresented: Bool
    let informations: [ToastInformationType]
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center) {
                Spacer()
                
                if isPresented {
                    ForEach(informations, id: \.title) { info in
                        Button(action: {
                            info.action()
                            isPresented = false
                        }) {
                            Text(info.title)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 62)
                                .font(.semoBold(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.card)
                    )
                    .cornerRadius(10)
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 20)
        }
        .animation(.interactiveSpring(), value: isPresented)
    }
    
    init(_ container: Binding<some ToastContainerType>,
         _ informations: [some ToastInformationType]) {
        self._isPresented = container.isPresented
        self.informations = informations
    }
}
