//
//  SignInView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/18/20.
//

import SwiftUI
import FirebaseAnalytics

struct SignInView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewRouter: ViewRouter

    @State var email: String = ""
    @State var password: String = ""
    @State private var showingAlert = false
    @State private var isShowingForgotPassword = false

    var body: some View {
        ZStack {
            Image("Ridge_Path")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                WelcomeHeader(fontSize: 42.0, title: "Welcome Back")
                    .padding(.bottom, 40)
                SignInTextFields(parentSignInView: self)

                Button(action: forgotPassword) {
                    Text("Forgot Password?")
                        .font(Font.avenirMedium(withSize: 21.0))
                        .foregroundColor(.white)
                        .fixedSize()
                }
                .sheet(isPresented: $isShowingForgotPassword) {
                    ForgotPasswordScreen(titleText: "Forgot your password?")
                }

                Spacer()
                Button(action: signIn) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.Custom.backgroundGreen)
                            .cornerRadius(20.0)
                        Text("Sign In")
                            .font(Font.avenirMedium(withSize: 28.0))
                            .foregroundColor(.white)
                            .frame(minWidth: 300)
                            .fixedSize()
                            .padding(15.0)
                            .layoutPriority(1)
                    }
                }
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Could not sign in"),
                          message: Text("The username or password do not match any records in our system."),
                          dismissButton: .default(Text("Got it!")))
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationBackButton(buttonAction: {
            self.presentationMode.wrappedValue.dismiss()
        }))
    }

    private func signIn() {
        let userInfo = SignInInfo(email: email, password: password)
        let signInRequest = APIRequestFactory.signInUser(userCrudentials: userInfo)
        APIClient.shared.perform(request: signInRequest) { userToken in
            KeyChain.shared.userAccessToken = userToken.userToken
            KeyChain.shared.mostRecentPasswordResetToken = nil
            viewRouter.currentState = .authenticated
            Analytics.logEvent("New_App_Launch", parameters: [:])
        } failure: { error, response in
            showingAlert = true
        }
    }

    private func forgotPassword() {
        isShowingForgotPassword = true
    }
}

private struct SignInTextFields: View {

    let parentSignInView: SignInView

    var body: some View {
        VStack(spacing: 20) {
            let placeholder = Text("Enter your email").foregroundColor(.gray)
            PlaceholderTextField(placeholder: placeholder,
                                 textFieldContentType: .emailAddress,
                                 textFieldKeyBoardType: .emailAddress,
                                 text: parentSignInView.$email)
            Divider()
            PlaceholderSecureField(placeholder: Text("Enter your password").foregroundColor(.gray),
                                   text: parentSignInView.$password)
            Divider()
        }
        .padding([.leading, .trailing], 15)
        .padding([.top], 25)
        .padding([.bottom], 12)
        .frame(width: UIScreen.main.bounds.width - 32.0)
        .fixedSize()
        .background(Color.white)
        .cornerRadius(15.0)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
