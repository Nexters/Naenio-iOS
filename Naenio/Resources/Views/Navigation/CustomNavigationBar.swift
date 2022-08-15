//
//  CustomNavigationBar.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let title: String
    var trailingButton: CustomNavigationButton?
    
    var body: some View {
        ZStack(alignment: .center) {
            buttons
                .fillHorizontal()
            
            Text(title)
                .font(.semoBold(size: 18))
                .foregroundColor(.white)
        }
    }
    
    var buttons: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            trailingButton
        }
    }
    
    init(title: String, button: CustomNavigationButton? = nil) {
        self.title = title
        self.trailingButton = button
    }
}
