//
//  EmojiTextField.swift
//  Achievements
//
//  Created by Yuki Takahashi on 04/02/2021.
//

import SwiftUI
import Combine

struct EmojiTextFieldWrapperView: UIViewRepresentable {

    @Binding var text: String
    
    let textField = EmojiTextField()

    func makeUIView(context: UIViewRepresentableContext<EmojiTextFieldWrapperView>) -> UITextField {
        //textField.delegate = context.coordinator
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<EmojiTextFieldWrapperView>) {
        self.textField.text = text
    }

    func makeCoordinator() -> EmojiTextFieldWrapperView.Coordinator {
        let coordinator = Coordinator(self)
        return coordinator
    }
    
    typealias UIViewType = UITextField
    
    class Coordinator: NSObject {
        let owner: EmojiTextFieldWrapperView
        private var subscriber: AnyCancellable

        init(_ owner: EmojiTextFieldWrapperView) {
            self.owner = owner
            subscriber = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: owner.textField)
                .sink(receiveValue: { _ in
                    owner.$text.wrappedValue = owner.textField.text ?? ""
                })
        }

        @objc fileprivate func onSet() {
            owner.textField.resignFirstResponder()
        }
    }
}

class EmojiTextField: UITextField {

    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
