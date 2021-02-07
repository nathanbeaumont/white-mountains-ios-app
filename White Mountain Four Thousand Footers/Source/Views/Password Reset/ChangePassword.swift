//
//  ChangePassword.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 2/7/21.
//

import SwiftUI

struct ChangePassword: View {

    private enum ActiveAlert {
        case success, failure, passwordValidtion
    }
    @State private var activeAlert: ActiveAlert = .success

    @State fileprivate var password: String = ""
    @State fileprivate var repeatPassword: String = ""

    @State private var passwordAlertText: String = ""
    @State private var showingAlertView = false

    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack {
            Image("Water_Pool")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Change your password")
                    .foregroundColor(.white)
                    .font(Font.avenirHeavy(withSize: 24.0))
                    .padding([.top, .bottom], 16.0)
                ChangePasswordFields(parentView: self)
                Spacer()

                Button(action: finishChangePassword) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.Custom.backgroundGreen)
                            .cornerRadius(20.0)
                        Text("Change Password")
                            .font(Font.avenirMedium(withSize: 28.0))
                            .foregroundColor(.white)
                            .frame(minWidth: 300)
                            .fixedSize()
                            .padding(15.0)
                            .layoutPriority(1)
                    }
                }
                .alert(isPresented: $showingAlertView) {
                    switch activeAlert {
                    case .success:
                        return Alert(title: Text("Success"),
                                     message: Text("Password successfully updated!"),
                                     dismissButton: .default(Text("Okay"), action: {
                                        viewRouter.currentState = .registration
                                     }))
                    case .failure:
                        return Alert(title: Text("Error Changing Password"),
                                     message: Text("User account could not be created. This email may already be in use."),
                                     dismissButton: .default(Text("Okay")))
                    case .passwordValidtion:
                        return Alert(title: Text("Error"),
                                     message: Text(passwordAlertText),
                                     dismissButton: .default(Text("Okay")))
                    }
                }
            }
        }
    }

    private func finishChangePassword() {
        guard let changePassword = ChangePasswordModel(newPassword: password) else { return }
        let validation = changePassword.validateInformation(repeatedPassword: repeatPassword)
        switch validation {
            case .passwordComplexity, .passwordsDoNotMatch:
                passwordAlertText = validation.rawValue
                activeAlert = .passwordValidtion
                showingAlertView = true
            case .valid:
                let changePassword = APIRequestFactory.changePassword(changePassword)
                APIClient.shared.perform(request: changePassword) { _ in
                    activeAlert = .success
                    showingAlertView = true
                } failure: { error, response in
                    activeAlert = .failure
                    showingAlertView = true
                }
            case .nameLength, .emailInvalid:
                break
        }
    }

}

private struct ChangePasswordFields: View {

    let parentView: ChangePassword

    init(parentView: ChangePassword) {
        self.parentView = parentView
    }

    var body: some View {
        VStack(spacing: 20) {
            // Password Textfield
            PlaceholderSecureField(placeholder: Text("Enter a password").foregroundColor(.gray),
                                          text: parentView.$password)
            Divider()

            // Confirm Password Textfield
            PlaceholderSecureField(placeholder: Text("Re-enter your password").foregroundColor(.gray),
                                          text: parentView.$repeatPassword)
            Divider()
        }
        .padding([.leading, .trailing], 15)
        .padding([.top], 25)
        .padding([.bottom], 10)
        .frame(width: UIScreen.main.bounds.width - 32)
        .background(Color.white)
        .cornerRadius(25.0)
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword()
    }
}
