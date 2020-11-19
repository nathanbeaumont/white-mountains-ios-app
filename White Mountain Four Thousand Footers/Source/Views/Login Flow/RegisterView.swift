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

    var body: some View {
        ZStack {
            Image("Trail_Path")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                WelecomeHeader()
                    .padding(.bottom, 50)
                RegisterTextFields()
                    .opacity(0.95)
                Spacer()

                Button(action: {

                }, label: {
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
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationBackButton(buttonAction: {
            self.presentationMode.wrappedValue.dismiss()
        }))
    }
}

private struct RegisterTextFields: View {

    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""

    private var textFieldBindings: [Binding<String>] {
        return [$email,
                $name,
                $password,
                $repeatPassword]
    }

    private var textFieldPlaceHolders = ["Enter your name",
                                         "Enter your email",
                                         "Enter a password",
                                         "Re-enter your password"]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<textFieldPlaceHolders.count) { index in
                placeholderTextField(index: index)
                Divider()
            }
        }
        .frame(minWidth: 350)
        .fixedSize()
        .padding([.leading, .trailing], 15)
        .padding([.top, .bottom], 25)
        .background(Color.white)
        .cornerRadius(25.0)
    }

    private func placeholderTextField(index: Int) -> PlaceholderTextField {
        let placeholder = Text(textFieldPlaceHolders[index]).foregroundColor(.gray)
        return PlaceholderTextField(placeholder: placeholder, text: textFieldBindings[index])
    }

    public func userInfo() -> RegisterInfo? {
        return RegisterInfo(email: email, name: name, password: password)
    }
}

private struct WelecomeHeader: View {
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.white)
                .opacity(0.4)
            Text("Welcome")
                .font(Font.avenirMedium(withSize: 72.0))
                .padding()
                .foregroundColor(.white)
                .layoutPriority(1)
        }
        .cornerRadius(15.0)
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(ViewRouter())
    }
}
