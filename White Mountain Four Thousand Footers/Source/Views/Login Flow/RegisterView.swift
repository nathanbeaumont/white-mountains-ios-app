//
//  RegisterView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/11/20.
//

import SwiftUI

struct RegisterView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var email: String = ""
    @State var name: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    @State private var showingAlert = false
    @EnvironmentObject var viewRouter: ViewRouter

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
                          message: Text("User account could not be created. This email may already be in use."),
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
        if let userInfo = RegisterInfo(email: email, name: name, password: password) {
            let createNewUserRequest = APIRequestFactory.createNewUser(newUser: userInfo)
            APIClient.perform(request: createNewUserRequest) { userToken in
                KeyChain.shared.userAccessToken = userToken.userToken
                viewRouter.currentState = .authenticated

                // Set Home Screen
            } failure: { error, response in
                if response.response?.statusCode == 400 {
                    // User already exists error
                    showingAlert = true
                }
            }

        }
    }
}

private struct RegisterTextFields: View {

    let parentReigstrationView: RegisterView

    private var textFieldBindings: [Binding<String>] {
        return [parentReigstrationView.$name,
                parentReigstrationView.$email,
                parentReigstrationView.$password,
                parentReigstrationView.$repeatPassword]
    }
    private var textFieldPlaceHolders = ["Enter your name",
                                         "Enter your email",
                                         "Enter a password",
                                         "Re-enter your password"]

    init(parentView: RegisterView) {
        parentReigstrationView = parentView
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<textFieldPlaceHolders.count) { index in
                if index <= 1 { placeholderTextField(index: index) }
                if index > 1 { placeholderSecureField(index: index) }

                Divider()
            }
        }
        .frame(minWidth: 350)
        .fixedSize()
        .padding([.leading, .trailing], 15)
        .padding([.top], 25)
        .padding([.bottom], 10)
        .background(Color.white)
        .cornerRadius(25.0)
    }

    private func placeholderTextField(index: Int) -> PlaceholderTextField {
        let placeholder = Text(textFieldPlaceHolders[index]).foregroundColor(.gray)
        return PlaceholderTextField(placeholder: placeholder,
                                    text: textFieldBindings[index])

    }

    private func placeholderSecureField(index: Int) -> PlaceholderSecureField {
        let placeholder = Text(textFieldPlaceHolders[index]).foregroundColor(.gray)
        return PlaceholderSecureField(placeholder: placeholder,
                                      text: textFieldBindings[index])
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
