//
//  RegisterView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/11/20.
//

import SwiftUI

struct RegisterView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewRouter: ViewRouter

    @State var email: String = ""
    @State var name: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""

    @State private var showingAlert = false
    @State private var alertText: String = ""

    var body: some View {
        ZStack {
            Image("Trail_Path")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                WelcomeHeader(title: "Welcome")
                    .padding(.bottom, 50)
                RegisterTextFields(parentView: self)
                Spacer()

                Button(action: registrationCompleted) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.Custom.backgroundGreen)
                            .cornerRadius(20.0)
                        Text("Complete Registration")
                            .font(Font.avenirMedium(withSize: 25.0))
                            .foregroundColor(.white)
                            .fixedSize()
                            .padding(15.0)
                            .layoutPriority(1)
                    }
                }
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Error Creating User"),
                          message: Text(alertText),
                          dismissButton: .default(Text("Got it!")))
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationBackButton(buttonAction: {
            self.presentationMode.wrappedValue.dismiss()
        }))
    }

    private func registrationCompleted() {
        let userInfo = RegisterInfo(email: email, name: name, password: password)
        let validation = userInfo.validateInformation(repeatedPassword: repeatPassword)
        switch validation {
            case .nameLength, .emailInvalid, .passwordComplexity, .passwordsDoNotMatch:
                alertText = validation.rawValue
                showingAlert = true
            case .valid:
                let createNewUserRequest = APIRequestFactory.createNewUser(newUser: userInfo)
                APIClient.shared.perform(request: createNewUserRequest) { userToken in
                    KeyChain.shared.userAccessToken = userToken.userToken
                    viewRouter.currentState = .authenticated

                    // Set Home Screen
                } failure: { error, response in
                    if response.response?.statusCode == 400 {
                        // User already exists error
                        alertText = "User account could not be created. This email may already be in use."
                        showingAlert = true
                    }
                }
        }
    }
}

private struct RegisterTextFields: View {

    let parentReigstrationView: RegisterView

    init(parentView: RegisterView) {
        parentReigstrationView = parentView
    }

    var body: some View {
        VStack(spacing: 20) {
            // Name TextField
            PlaceholderTextField(placeholder: Text("Enter your name").foregroundColor(.gray),
                                 textFieldContentType: .name,
                                 text: parentReigstrationView.$name)
            Divider()

            // Email TextField
            PlaceholderTextField(placeholder: Text("Enter your email").foregroundColor(.gray),
                                 textFieldContentType: .emailAddress,
                                 textFieldKeyBoardType: .emailAddress,
                                 text: parentReigstrationView.$email)
            Divider()

            // Password Textfield
            PlaceholderSecureField(placeholder: Text("Enter a password").foregroundColor(.gray),
                                          text: parentReigstrationView.$password)
            Divider()

            // Confirm Password Textfield
            PlaceholderSecureField(placeholder: Text("Enter a password").foregroundColor(.gray),
                                          text: parentReigstrationView.$repeatPassword)
            Divider()
        }
        .frame(minWidth: 350)
        .fixedSize()
        .padding([.leading, .trailing], 15)
        .padding([.top], 25)
        .padding([.bottom], 10)
        .background(Color.white)
        .cornerRadius(25.0)
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
