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
    @Binding var url: URL?
    var onNavigationFinished: (URL) -> Void
    
    // Add a variable to store JavaScript code
    var javascriptCodes: [String]?
    

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = [] // Autoplay without user interaction
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
        
        //addGestureRecognizers(to: webView)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url!)
        webView.load(request)

        // Check if there's JavaScript code to run
        if let javascriptCodes = javascriptCodes {
            let javascriptCode = String("(function() {") + javascriptCodes.joined(separator: " ") + String("})();")
            webView.evaluateJavaScript(javascriptCode, completionHandler: nil)
        }
            
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
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
            if let url = webView.url {
                parent.url = url
                parent.onNavigationFinished(url)
            }
        }

    }
      
}

