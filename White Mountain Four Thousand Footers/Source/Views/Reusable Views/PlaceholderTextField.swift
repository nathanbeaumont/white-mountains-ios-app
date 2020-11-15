//
//  PlaceholderTextField.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/15/20.
//

import SwiftUI

struct PlaceholderTextField: View {
    var placeholder: Text
    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = { }

    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct PlaceholderTextField_Previews: PreviewProvider {

    @State var text: String

    static var previews: some View {
        StatefulPreviewWrapper("") {
            PlaceholderTextField(placeholder: Text("Nathan")
                                    .foregroundColor(.red), text: $0)
        }
    }
}
