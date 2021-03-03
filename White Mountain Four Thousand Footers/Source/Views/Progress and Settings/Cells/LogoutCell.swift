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
                                    MountainDataSource.shared.clearDataSource()
                                    AppSession.shared.removeAuthentication()
                                    viewRouter.currentState = .registration
                                }),
                                secondaryButton: Alert.Button.default(Text("Cancel"))) }
        )
    }
}

struct DeleteCell: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showAlert = false

    var body: some View {
        SettingsCell(title: "Delete") {
            showAlert.toggle()
        }
        .alert(isPresented: $showAlert,
               content: { Alert(title: Text("Are you sure?"),
                                message: Text("This will permanently remove all of your user data."),
                                primaryButton:
                                    Alert.Button.destructive(Text("Delete"),
                                action: {
                                    let apiRequest = APIRequestFactory.deleteUser()
                                    APIClient.shared.perform(request: apiRequest) { error in
                                        AppSession.shared.removeAuthentication()
                                        viewRouter.currentState = .registration
                                    }
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
