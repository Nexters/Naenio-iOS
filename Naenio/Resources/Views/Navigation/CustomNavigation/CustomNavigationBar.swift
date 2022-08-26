//
//  CustomNavigationBar.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    var leadingButton: CustomNavigationBackButton?
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
            leadingButton
            
            Spacer()
            
            trailingButton
        }
    }
    
    init(title: String,
         leading: CustomNavigationBackButton?,
         trailing: CustomNavigationButton?) {
        self.title = title
        self.leadingButton = leading
        self.trailingButton = trailing
    }
}
