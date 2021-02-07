//
//  ForgotPasswordScreen.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 2/6/21.
//

import SwiftUI

struct ForgotPasswordScreen: View {

    @State var emailAddress: String = ""
    @State private var showingErrorAlert = false
    @State private var showingSuccessAlert = false

    var body: some View {
        ZStack {
            Image("Snowy_Lookout")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 8.0) {
                Text("Forgot your password?")
                    .foregroundColor(.white)
                    .font(Font.avenirMedium(withSize: 24.0))
                Text("Enter your email associated with your account. If the email is in our database a reset password email will arrive in your inbox. Please be sure to check your spam.")
                    .foregroundColor(.white)
                    .font(Font.avenirMedium(withSize: 17.0))
                    .multilineTextAlignment(.center)

                PlaceholderTextField(placeholder: Text("Enter your email").foregroundColor(.gray),
                                     textFieldContentType: .emailAddress,
                                     textFieldKeyBoardType: .emailAddress,
                                     text: $emailAddress)
                    .frame(height: 45)
                    .padding(.leading, 15.0)
                    .background(Color.white)
                    .cornerRadius(15.0)
                    .alert(isPresented: $showingSuccessAlert, content: {
                        Alert(title: Text("Success!"),
                              message: Text("A reset password email has been sent to your inbox."),
                              dismissButton: .default(Text("Okay")))
                    })
                
                Spacer()

                Button(action: sendEmail) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.Custom.backgroundGreen)
                            .cornerRadius(20.0)
                        Text("Send Email")
                            .font(Font.avenirMedium(withSize: 28.0))
                            .foregroundColor(.white)
                            .frame(minWidth: 300)
                            .fixedSize()
                            .padding(15.0)
                            .layoutPriority(1)
                    }
                }
                .alert(isPresented: $showingErrorAlert, content: {
                    Alert(title: Text("Could not find Email"),
                          message: Text("The email entered above was not found in our database. Please check your spelling."),
                          dismissButton: .default(Text("Okay")))
                })
            }
            .padding(.top, 16.0)
            .frame(width: UIScreen.main.bounds.width - 32.0)

        }
    }

    private func sendEmail() {
        guard emailAddress.isValidEmail() else {
            showingErrorAlert = true
            return
        }

        let apiRequest = APIRequestFactory.initiateForgotPassword(emailAddress: emailAddress)
        APIClient.shared.perform(request: apiRequest) { (apiError) in
            showingSuccessAlert = true
        } failure: { (error, dataResponse) in
            showingErrorAlert = true
        }

    }
}

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen()
    }
}
