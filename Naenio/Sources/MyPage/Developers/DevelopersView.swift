//
//  DevelopersView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct DevelopersView: View {
    var body: some View {
        CustomNavigationView(title: "개발자 정보") {
            VStack {
                Description(division: "디자이너", names: ["박주리", "곽민주"])
                Description(division: "디자이너", names: ["박주리", "곽민주"])
                Description(division: "디자이너", names: ["박주리", "곽민주"])
                Description(division: "디자이너", names: ["박주리", "곽민주"])
            }
        }
    }
    
    private struct Description: View {
        let division: String
        let names: [String]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(division)
                    .font(.engMedium(size: 16))
                
                HStack(spacing: 0) {
                    ForEach(names, id: \.self) { name in
                        Text(name)
                        Text(", ")
                    }
                }
            }
        }
    }
}
