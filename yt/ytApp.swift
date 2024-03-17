//
//  ytApp.swift
//  yt
//
//  Created by Isaac Ramonet on 12/11/2023.
//

import SwiftUI
import AVFoundation

@main
struct ytApp: App {
    
    init() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
