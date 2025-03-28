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


    let youtubeURL = URL(string: "https://m.youtube.com")!
    let javascriptCodes: [String] = loadJsCodes()


    var body: some View {
        NavigationView {
            if !javascriptCodes.isEmpty {
            WebView(navigation: webViewNavigation, url: youtubeURL, javascriptCodes: loadJsCodes())
            } else {
                WebView(navigation: webViewNavigation, url: youtubeURL)
                    .navigationBarTitle("YouTube Browser", displayMode: .inline)
            }
        }.alert(isPresented: $connectivityViewModel.showAlert) {
            Alert(
                title: Text("No Internet Connection"),
                message: Text("Please check your internet connection and try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().edgesIgnoringSafeArea(.all)
    }
}
