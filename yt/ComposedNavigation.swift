//
//  ComposedNavigation.swift
//  yt
//
//  Created by Isaac Ramonet on 23/01/2024.
//

import SwiftUI

struct WebViewWithNavigation: View {
    @ObservedObject private var webViewNavigation = WebViewNavigation()
    
    var body: some View {
        VStack {
            WebView(urlString: "https://www.example.com", navigation: webViewNavigation)
            
            NavigationToolBar(navigation: webViewNavigation)
        }
    }
}

