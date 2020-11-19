//
//  SignInView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 11/7/20.
//

import SwiftUI

struct SignInLandingView: View {

    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        NavigationView {
            ZStack {
                Image("White_Mountain_Ridge")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("White Mountain\n Four Thousand Footer\nPeak Tracker")
                        .font(Font.avenirMedium(withSize: 36.0))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(8.0)
                        .background(Color.clear)
                        .cornerRadius(15.0)
                    Spacer()
                    
                    VStack {
                        LoginButton(buttonTitle: "Register",
                                    background: Color.Custom.backgroundGreen)
                            .padding(.bottom, 10)

                        LoginButton(buttonTitle: "Sign In",
                                    background: Color.Custom.darkBackgroundGreen)
                    }
                    .padding(.bottom, 30)
                }
            }
        }.accentColor(.white)
    }

    private static var computedValue: ((ViewDimensions) -> CGFloat) {
        return { _ in return CGFloat(8.0) }
    }
}

struct LoginButton: View {

    let buttonTitle: String
    let background: Color

    var body: some View {
        NavigationLink(destination: RegisterView()) {
            Text(buttonTitle)
            .frame(width: 325, height: 60, alignment: .center)
            .font(Font.avenirMedium(withSize: 24.0))
            .foregroundColor(.white)
            .background(background)
            .cornerRadius(15.0)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInLandingView()
                .environmentObject(ViewRouter())
                .previewDevice("iPhone 11")
        }
    }
}