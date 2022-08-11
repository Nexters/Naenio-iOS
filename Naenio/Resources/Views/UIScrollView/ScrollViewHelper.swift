//
//  ScrollViewHelper.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/10.
//

import SwiftUI

/// UIKit의 UIScrollView 기능을 사용할 수 있게 만들어주는 helper 클래스입니다
///
/// 내부에서 `UIScrollViewDelegate`를 채택해 scroll view에 대한 정보를 클래스 내부에 업데이트합니다.
/// `ObservableObject`를 채택해 업데이트 된 변수에 대한 정보를 받아옵니다.
class ScrollViewHelper: NSObject, ObservableObject {
    @Published var scrollDirection: ScrollDirection = .downward
    
    let refreshController = UIRefreshControl()
    
    enum ScrollDirection {
        case upward
        case downward
    }
}

extension ScrollViewHelper: UIScrollViewDelegate {
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
