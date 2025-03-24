//
//  Connectivity.swift
//  yt
//
//  Created by Isaac Ramonet on 18/12/2023.
//

import SwiftUI
import Network


class ConnectivityViewModel: ObservableObject {
    private let monitor = NWPathMonitor()
    
    @Published var isConnected = true
    @Published var showAlert = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            // Perform updates on the main thread
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                if !self!.isConnected {
                    self?.showAlert = true
                }
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
