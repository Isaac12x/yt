//
//  WebViewNavigation.swift
//  yt
//
//  Created by Isaac Ramonet on 23/01/2024.
//

import SwiftUI
import WebKit

class WebViewNavigation: ObservableObject {
    var webView: WKWebView?
    
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    
    init() {
        self.webView = WKWebView()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         canGoBack = webView.canGoBack
         canGoForward = webView.canGoForward
     }
    
    func goBack() {
        webView?.goBack()
    }
    
    func goForward() {
        webView?.goForward()
    }
}
