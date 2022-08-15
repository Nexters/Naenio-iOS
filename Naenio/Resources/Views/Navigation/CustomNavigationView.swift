//
//  CustomNavigationView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct CustomNavigationView<V>: View where V: View {
    let title: String
    let content: V
    
    let trailingButton: CustomNavigationButton?
    let bgColor: Color = .background
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                self.bgColor
                    .ignoresSafeArea()
                
                CustomNavigationBar(title: self.title, button: trailingButton)
                    .padding(.top, 17)
                    .padding(.horizontal, 20)
            }
            
            content
        }
    }
    
    init(title: String, trailingButton: CustomNavigationButton? = nil, @ViewBuilder _ content: () -> V) {
        self.title = title
        self.content = content()
        self.trailingButton = trailingButton
    }
}
