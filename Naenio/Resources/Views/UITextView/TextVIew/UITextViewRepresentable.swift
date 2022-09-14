//
//  UITextView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct RepresentedUITextView: UIViewRepresentable {
    let limit: Int?
    let isTight: Bool
    let allowNewline: Bool
    let allowWhiteSpace: Bool
    
    @Binding var becomeFirstResponder: Bool
    @Binding var text: String
    @Binding var isEditing: Bool
    
    init(text: Binding<String>, isEditing: Binding<Bool>, limit: Int? = nil,
         isTight: Bool, allowNewline: Bool = true, allowWhiteSpace: Bool = true,
         becomeFirstResponder: Binding<Bool> = .constant(false)
    ) {
        self._text = text
        self._isEditing = isEditing
        self.limit = limit
        self.isTight = isTight
        self.allowNewline = allowNewline
        self.allowWhiteSpace = allowWhiteSpace
        self._becomeFirstResponder = becomeFirstResponder
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, limit, allowNewline, allowWhiteSpace, $becomeFirstResponder)
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
        textView.textContainerInset = UIEdgeInsets(top: isTight ? 8 : 16,
                                                   left: 16,
                                                   bottom: isTight ? 8 : 16,
                                                   right: 16)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        
        if becomeFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RepresentedUITextView
        let limit: Int?
        let allowNewline: Bool
        let allowWhiteSpace: Bool
        var becomeFirstResponder: Binding<Bool>

        init(_ uiTextView: RepresentedUITextView, _ limit: Int?, _ allowNewline: Bool,
             _ allowWhiteSpace: Bool, _ becomeFirstResponder: Binding<Bool>) {
            self.parent = uiTextView
            self.limit = limit
            self.allowNewline = allowNewline
            self.allowWhiteSpace = allowWhiteSpace
            self.becomeFirstResponder = becomeFirstResponder
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.isEditing = true
                self.becomeFirstResponder.wrappedValue = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.isEditing = false
                self.becomeFirstResponder.wrappedValue = false
            }
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            guard let limit = limit else {
                self.parent.text = textView.text
                return
            }
            
            // Possible overheadds
            if allowNewline == false,
               let newlineLocation = textView.text.firstIndex(where: { $0.isNewline }) {
                   textView.text.remove(at: newlineLocation)
            }
            
            // Possible overheadds
            if allowWhiteSpace == false,
               let whitespaceLocation = textView.text.firstIndex(where: { $0.isWhitespace }) {
                   textView.text.remove(at: whitespaceLocation)
            }
            
            if textView.text.count > limit {
                textView.text = String(textView.text.prefix(limit))
            }
            
            self.parent.text = textView.text
        }
    }
}
