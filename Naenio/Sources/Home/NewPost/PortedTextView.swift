//
//  UITextView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct UITextViewRepresentable: UIViewRepresentable {
    let limit: Int?
    @Binding var text: String
    
    init(text: Binding<String>, limit: Int? = nil) {
        self._text = text
        self.limit = limit
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, limit)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        textView.font = UIFont(name: "Pretendard-Medium", size: 16) // Font.medium(size: 16)
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor(Color.card)
        
        textView.textColor = UIColor(Color.white)
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewRepresentable
        let limit: Int?

        init(_ uiTextView: UITextViewRepresentable, _ limit: Int?) {
            self.parent = uiTextView
            self.limit = limit
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            guard let limit = limit else {
                self.parent.text = textView.text
                return
            }
            
            if textView.text.count > limit {
                textView.text = String(textView.text.prefix(limit))
            }
            
            self.parent.text = textView.text
        }
    }
}
