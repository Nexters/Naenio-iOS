//
//  UITextView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct RepresentedUITextView: UIViewRepresentable {
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
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor(Color.card)
        
        textView.textColor = UIColor(Color.white)
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RepresentedUITextView
        let limit: Int?

        init(_ uiTextView: RepresentedUITextView, _ limit: Int?) {
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
