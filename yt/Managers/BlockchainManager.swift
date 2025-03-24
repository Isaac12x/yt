//
//  BlockchainManager.swift
//  yt
//
//  Created by Isaac Ramonet on 24/3/25.
//
import Foundation

class BlockchainManager {
    static let shared = BlockchainManager()

    private init() {
        startSessionExpirationTimer()
    }

    private var currentSession: Session?
    private let sessionDuration: TimeInterval = 2 * 60 * 60 // 2 hours
    private var expirationTimer: Timer?

    // MARK: - Session Management
    func startNewSession() {
        // End the current session if it exists
        if let session = currentSession {
            DatabaseManager.shared.endSession(session)
        }

        // Start a new session
        let newSession = Session(startTime: Date())
        DatabaseManager.shared.insertSession(newSession)
        currentSession = newSession
    }

    func checkSessionExpiration() {
        guard let session = currentSession else {
            print("No active session. Starting a new session.")
            startNewSession()
            return
        }

        let elapsedTime = Date().timeIntervalSince(session.startTime)
        if elapsedTime > sessionDuration {
            print("Session expired. Starting a new session.")
            startNewSession()
        }
    }

    private func startSessionExpirationTimer() {
        expirationTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkSessionExpiration()
        }
    }

    // MARK: - Block Management
    func addBlock(url: URL) {
        guard let session = currentSession else {
            print("No active session. Start a new session first.")
            return
        }

        let previousHash = DatabaseManager.shared.fetchBlocks(for: session.id).last?.hash ?? "0"
        let block = Block(sessionID: session.id, url: url, previousHash: previousHash)
        DatabaseManager.shared.insertBlock(block)
    }

    func fetchBlocks() -> [Block] {
        guard let session = currentSession else { return [] }
        return DatabaseManager.shared.fetchBlocks(for: session.id)
    }

    // MARK: - Load Active Session
    func loadActiveSession() {
        if let activeSession = DatabaseManager.shared.fetchActiveSession() {
            currentSession = activeSession
        } else {
            startNewSession()
        }
    }
}
