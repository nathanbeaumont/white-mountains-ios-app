//
//  SignInView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/18/20.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        ZStack {
            Image("Ridge_Path")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                WelcomeHeader(fontSize: 42.0, title: "Welcome Back")
                    .padding(.bottom, 40)
                SignInTextFields()
                Spacer()
                Button(action: {

                }, label: {
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
                })
            }
        }
    }
}

private struct SignInTextFields: View {

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            let placeholder = Text("Enter your email").foregroundColor(.gray)
            PlaceholderTextField(placeholder: placeholder,
                                 text: $email)
            Divider()
            PlaceholderSecureField(placeholder: Text("Enter your password").foregroundColor(.gray),
                                   text: $password)
            Divider()
        }
        .frame(minWidth: 350)
        .fixedSize()
        .padding([.leading, .trailing], 15)
        .padding([.top], 25)
        .padding([.bottom], 12)
        .background(Color.white)
        .cornerRadius(15.0)
    }

    public func userInfo() -> SignInInfo? {
        return SignInInfo(email: email, password: password)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
