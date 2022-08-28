//
//  ForEach + Extension.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/18.
//

import SwiftUI

extension ForEach where ID == Data.Element.ID,
                        Data.Element: Identifiable,
                        Content: View {
    init<T>(
        _ data: Binding<T>,
        @ViewBuilder content: @escaping (T.Index, Binding<T.Element>) -> Content
    ) where Data == IdentifiableIndices<T>, T: MutableCollection {
        self.init(data.wrappedValue.identifiableIndices) { index in
            content(
                index.rawValue,
                Binding(
                    get: { data.wrappedValue[index.rawValue] },
                    set: { data.wrappedValue[index.rawValue] = $0 }
                )
            )
        }
    }
}

extension RandomAccessCollection where Element: Identifiable {
    var identifiableIndices: IdentifiableIndices<Self> {
        IdentifiableIndices(base: self)
    }
}

// MARK: -
struct IdentifiableIndices<Base: RandomAccessCollection> where Base.Element: Identifiable {
    
    typealias Index = Base.Index
    
    struct Element: Identifiable {
        let id: Base.Element.ID
        let rawValue: Index
    }
    
    fileprivate var base: Base
}

extension IdentifiableIndices: RandomAccessCollection {
    var startIndex: Index { base.startIndex }
    var endIndex: Index { base.endIndex }
    
    subscript(position: Index) -> Element {
        Element(id: base[position].id, rawValue: position)
    }
    
    func index(before index: Index) -> Index {
        base.index(before: index)
    }
    
    func index(after index: Index) -> Index {
        base.index(after: index)
    }
}
