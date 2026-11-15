//
//  SettingsView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/9/21.
//

import SwiftUI

struct SettingsView: View {

    @ObservedObject fileprivate var mountainDataSource = MountainDataSource.shared
    @State var progress: Float = 0.0
    @State var progressText: String = ""

    var body: some View {
        VStack {
            ProgressView(progressValue: $progress, progressText: $progressText)
            Spacer()

            Text("Application Version: \(AppConstants.appVersion)")
                .font(Font.avenirHeavy(withSize: 17.0))
                .padding(.bottom, 8)
        }.onAppear(perform: {
            mountainDataSource.getPeaksBagged()
            updateProgress()
        })
    }

    private func updateProgress() {
        let _ = mountainDataSource.$mountainBags.sink { mountainPeaksHiked in
            progress = 1 - Float((mountainDataSource.mountainPeaks.count - mountainPeaksHiked.count)) / Float(mountainDataSource.mountainPeaks.count)
            progressText = "You've hiked \(mountainPeaksHiked.count) out of 48 peaks!"
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
