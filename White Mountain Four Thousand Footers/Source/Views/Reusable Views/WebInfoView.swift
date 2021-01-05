//
//  WebInfoView.swift
//  White Mountain Four Thousand Footers
//
//  Created by Nathan Beaumont on 1/4/21.
//

import SwiftUI
import WebKit

struct WebInfoView: View {

    @Environment(\.presentationMode) var presentationMode
    var url: URL

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                })
                .frame(alignment: .top)
                .padding(.leading)

                Spacer()
            }

            WebView(url: self.url)
            Spacer()
        }.padding(.top)
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        webView.load(URLRequest(url: url))
       return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}

struct WebInfoView_Previews: PreviewProvider {
    static var previews: some View {
        WebInfoView(url: URL(string: "www.apple.com")!)
    }
}
