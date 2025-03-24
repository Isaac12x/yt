//
//  Data.swift
//  yt
//
//  Created by Isaac Ramonet on 23/3/25.
//

import Foundation
import CryptoKit

struct Block: Codable, Identifiable {
    let id: UUID
    let sessionID: UUID
    let url: URL
    let timestamp: Date
    let previousHash: String
    let hash: String

    init(sessionID: UUID, url: URL, previousHash: String) {
        self.id = UUID()
        self.sessionID = sessionID
        self.url = url
        self.timestamp = Date()
        self.previousHash = previousHash
        self.hash = Block.calculateHash(url: url, timestamp: self.timestamp, previousHash: previousHash)
    }
    
    init(sessionID: UUID, id: UUID, timestamp: Date, url: URL, previousHash: String, hash: String) {
        self.id = id
        self.sessionID = sessionID
        self.url = url
        self.timestamp = timestamp
        self.previousHash = previousHash
        self.hash = hash
    }

    static func calculateHash(url: URL, timestamp: Date, previousHash: String) -> String {
        let data = "\(url.absoluteString)\(timestamp)\(previousHash)"
        let hash = SHA256.hash(data: Data(data.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
