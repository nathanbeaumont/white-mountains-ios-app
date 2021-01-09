//
//  ProgressView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/9/21.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.1)
                .foregroundColor(Color.Custom.darkBackgroundGreen)

            Circle()
                .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.Custom.darkBackgroundGreen)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)

            Text(String(format: "%0.0f%%", min(self.progress, 1.0) * 100.0))
                .font(Font.avenirMedium(withSize: 30.0))
                .bold()
        }
    }
}

struct ProgressView: View {
    @Binding var progressValue: Float
    @Binding var progressText: String

    var body: some View {
        ZStack {
            Color.Custom.backgroundGreen
                .opacity(0.1)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            VStack {
                ProgressBar(progress: self.$progressValue)
                    .frame(width: 150.0, height: 150.0)
                    .padding([.top, .bottom], 12)
                Text(progressText)
                    .font(Font.avenirMedium(withSize: 19.0))
                    .padding(.bottom, 16)
                Image("Mountain_Peak")
                    .resizable()
                    .frame(width: 100, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }

        }
    }
}


//struct ProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressView(progressValue: 0.4, progressText: "Helllo World")
//    }
//}
