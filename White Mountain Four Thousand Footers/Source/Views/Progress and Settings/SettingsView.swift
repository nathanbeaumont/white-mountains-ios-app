//
//  SettingsView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/9/21.
//

import SwiftUI

struct SettingsCell: View {
    var title: String
    var action: (() -> Void)?

    var body: some View {
        VStack {
            Text(title)
                .font(Font.avenirMedium(withSize: 17.0))
        }
    }
}

struct SettingsView: View {

    @ObservedObject fileprivate var mountainDataSource = MountainDataSource.shared
    @State var progress: Float = 0.0
    @State var progressText: String = ""

    var body: some View {
        VStack {
            ProgressView(progressValue: $progress, progressText: $progressText)
            List {
                SettingsCell(title: "Change Password", action: nil)
                SettingsCell(title: "Delete Account", action: nil)
                SettingsCell(title: "Application Version: \(AppConstants.appVersion)", action: nil)
            }
        }.onAppear(perform: {
            mountainDataSource.getPeaksBagged()
            updateProgress()
        })
    }

    private func updateProgress() {
        let _ = mountainDataSource.$mountainPeaksHiked.sink { mountainPeaksHiked in
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
