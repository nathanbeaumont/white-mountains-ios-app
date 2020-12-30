//
//  PlaceholderTextField.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/15/20.
//

import SwiftUI

struct PlaceholderTextField: View {

    var commit: () -> () = { }
    var editingChanged: (Bool) -> () = { _ in }
    var placeholder: Text
    var textFieldContentType: UITextContentType = .name
    var textFieldKeyBoardType: UIKeyboardType = .default

    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .textContentType(textFieldContentType)
                .keyboardType(textFieldKeyBoardType)
                .autocapitalization(textFieldKeyBoardType == .emailAddress ? .none : .sentences)
                .disableAutocorrection(true)
                .accentColor(.black)
        }
    }
}

struct PlaceholderSecureField: View {
    var placeholder: Text
    var commit: () -> () = { }

    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text, onCommit: commit).accentColor(.black)
        }
    }
}

struct PlaceholderTextField_Previews: PreviewProvider {

    @State var text: String

    static var previews: some View {
        StatefulPreviewWrapper("") {
            PlaceholderSecureField(placeholder: Text("Nathan")
                                    .foregroundColor(.red), text: $0)
        }
    }
}
