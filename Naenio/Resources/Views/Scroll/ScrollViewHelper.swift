//
//  ScrollViewHelper.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/10.
//

import SwiftUI

class ScrollViewHelper: NSObject, ObservableObject {
    @Published var scrollDirection: ScrollDirection = .downward
    
    var lastScrollPosition: CGFloat = 0    
    var refreshController = UIRefreshControl()
    
    enum ScrollDirection {
        case upward
        case downward
    }
}

extension ScrollViewHelper: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastScrollPosition = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.1)) {
                    self.scrollDirection = .upward
                }
            }
        } else {
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.1)) {
                    self.scrollDirection = .downward
                }
            }
        }
    }
}
