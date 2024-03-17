//
//  WebView.swift
//  yt
//
//  Created by Isaac Ramonet on 12/11/2023.
//

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    @ObservedObject var navigation: WebViewNavigation
    var webView: WKWebView?
    let url: URL

    // Add a variable to store JavaScript code
    var javascriptCodes: [String]?
    

     func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = [] // Autoplay without user interaction
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
         
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)

        // Check if there's JavaScript code to run
        if let javascriptCodes = javascriptCodes {
            let javascriptCode = String("(function() {") + javascriptCodes.joined(separator: " ") + String("})();")
            uiView.evaluateJavaScript(javascriptCode, completionHandler: nil)
        }
            
        addGestureRecognizers(to: uiView)
    }
    
    private func addGestureRecognizers(to webView: WKWebView) {
        // TODO: future work
        //         let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapGesture(_:)))
        
        //         webView.addGestureRecognizer(tapGesture)
        // drag left -> goes back
        // drag right -> goes forward
        // drag down (within) -> dismisses player
     }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

    }
      
}

