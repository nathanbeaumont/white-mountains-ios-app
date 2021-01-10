//
//  LogoutCell.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/10/21.
//

import SwiftUI

struct LogoutCell: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showAlert = false

    var body: some View {
        SettingsCell(title: "Logout") {
            showAlert.toggle()
        }
        .alert(isPresented: $showAlert,
               content: { Alert(title: Text("Are you sure?"),
                                primaryButton:
                                    Alert.Button.destructive(Text("Logout"),
                                action: {
                                    AppSession.shared.removeAuthentication()
                                    viewRouter.currentState = .registration
                                }),
                                secondaryButton: Alert.Button.default(Text("Cancel"))) }
        )
    }
}

struct LogoutCell_Previews: PreviewProvider {
    static var previews: some View {
        LogoutCell()
    }
}
