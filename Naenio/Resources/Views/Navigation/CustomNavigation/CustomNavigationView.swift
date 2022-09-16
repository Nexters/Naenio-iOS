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
    
    let configuration: CustomNavigationConfiguration
    private let bgColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: self.title,
                                leading: configuration.leadingButton,
                                trailing: configuration.trailingButton)
            .padding(.vertical, 17)
            .padding(.horizontal, 20)
            .background(self.bgColor.ignoresSafeArea())
            
            content
                .fillScreen()
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
    
    init(title: String,
         showLeadingButton: Bool = true,
         configuration: CustomNavigationConfiguration = CustomNavigationConfiguration(),
         bgColor: Color = .background,
         isClear: Bool = false,
         @ViewBuilder _ content: () -> V) {
        self.title = title
        self.content = content()
        self.configuration = configuration
        self.bgColor = bgColor
        
        if showLeadingButton {
            configuration.leadingButton = CustomNavigationBackButton()
        }
    }
}
