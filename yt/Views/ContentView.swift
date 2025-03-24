//
//  ContentView.swift
//  yt
//
//  Created by Isaac Ramonet on 12/11/2023.
//

import SwiftUI
import WebKit

// Load JavaScript code from the file
func loadJsCodes() -> [String] {
    let folderName = "JS"
    let javascriptFileType = "js"
    var javascriptCodes: [String] = []
    
    // Get the URL of the JS folder in the main bundle
    if let jsFolderURL = Bundle.main.url(forResource: folderName, withExtension: nil) {
        do {
            // Get the contents of the directory
            let contents = try FileManager.default.contentsOfDirectory(at: jsFolderURL, includingPropertiesForKeys: nil, options: [])
            
            // Iterate over each file in the directory
            for fileURL in contents {
                var isDirectory: ObjCBool = false
                // Check if the item is a file and not a directory
                if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) && !isDirectory.boolValue {
                    // Check if the file is of type JavaScript
                    if fileURL.pathExtension == javascriptFileType {
                        // Load the JavaScript code
                        if let javascriptCode = try? String(contentsOf: fileURL) {
                            javascriptCodes.append(javascriptCode)
                        } else {
                            // Handle the case where the file couldn't be read
                            print("Failed to load JavaScript code from \(fileURL.lastPathComponent)")
                        }
                    }
                }
            }
        } catch {
            // Handle the case where the directory couldn't be read
            print("Failed to read contents of directory \(folderName)")
        }
    } else {
        // Handle the case where the folder couldn't be found
        print("Failed to locate folder")
    }
    return javascriptCodes
}


struct ContentView: View {
    @ObservedObject var connectivityViewModel = ConnectivityViewModel()
    @ObservedObject private var webViewNavigation = WebViewNavigation()
    @State private var currentURL: URL? = URL(string: "https://m.youtube.com")!
    @State private var blocks: [Block] = []
    let javascriptCodes: [String] = loadJsCodes()
    
    
    var body: some View {
        VStack{
            NavigationView {
                if !javascriptCodes.isEmpty {
                    WebView(navigation: webViewNavigation, url: $currentURL, onNavigationFinished: handleNavigation, javascriptCodes: loadJsCodes())
                    
                } else {
                    WebView(navigation: webViewNavigation, url: $currentURL, onNavigationFinished: handleNavigation)
                        .navigationBarTitle("YouTube Browser", displayMode: .inline).frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }.alert(isPresented: $connectivityViewModel.showAlert) {
                Alert(
                    title: Text("No Internet Connection"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
            List(blocks) { block in
                VStack(alignment: .leading) {
                    Text("URL: \(block.url)")
                        .font(.headline)
                    Text("Timestamp: \(block.timestamp)")
                        .font(.subheadline)
                    Text("Hash: \(block.hash)")
                        .font(.footnote)
                }
                .padding()
            }}
        .onAppear {
            // Load the active session when the view appears
            BlockchainManager.shared.loadActiveSession()
            blocks = BlockchainManager.shared.fetchBlocks()
            startSessionExpirationTimer()
        }
    }
    
    private func handleNavigation(url: URL) {
        // Called when the WebView finishes loading a page
        BlockchainManager.shared.addBlock(url: url)
        blocks = BlockchainManager.shared.fetchBlocks()
    }
    
    private func startSessionExpirationTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            BlockchainManager.shared.checkSessionExpiration()
            blocks = BlockchainManager.shared.fetchBlocks()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().edgesIgnoringSafeArea(.all)
    }
}
