//
//  DatabaseManager.swift
//  yt
//
//  Created by Isaac Ramonet on 24/3/25.
//
import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()

    private let db: Connection

    // Table definitions
    private let sessions = Table("sessions")
    private let blocks = Table("blocks")

    // Session columns
    private let sessionID = SQLite.Expression<String>("id")
    private let startTime = SQLite.Expression<Date>("start_time")
    private let endTime = SQLite.Expression<Date?>("end_time")
    private let isActive = SQLite.Expression<Bool>("is_active")

    // Block columns
    private let blockID = SQLite.Expression<String>("id")
    private let blockSessionID = SQLite.Expression<String>("session_id")
    private let url = SQLite.Expression<String>("url")
    private let timestamp = SQLite.Expression<Date>("timestamp")
    private let previousHash = SQLite.Expression<String>("previous_hash")
    private let hash = SQLite.Expression<String>("hash")

    private init() {
        // Initialize the database connection
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        db = try! Connection("\(path)/ytDB.sqlite3")

        // Create tables if they don't exist
        createTables()
    }

    private func createTables() {
        do {
            // Create sessions table
            try db.run(sessions.create(ifNotExists: true) { table in
                table.column(sessionID, primaryKey: true)
                table.column(startTime)
                table.column(endTime)
                table.column(isActive)
            })

            // Create blocks table
            try db.run(blocks.create(ifNotExists: true) { table in
                table.column(blockID, primaryKey: true)
                table.column(blockSessionID)
                table.column(url)
                table.column(timestamp)
                table.column(previousHash)
                table.column(hash)
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }

    // MARK: - Session Operations
    func insertSession(_ session: Session) {
        do {
            try db.run(sessions.insert(
                sessionID <- session.id.uuidString,
                startTime <- session.startTime,
                endTime <- session.endTime,
                isActive <- session.isActive
            ))
        } catch {
            print("Error inserting session: \(error)")
        }
    }

    func fetchActiveSession() -> Session? {
        do {
            if let row = try db.pluck(sessions.filter(isActive == true)) {
                return Session(
                    id: UUID(uuidString: row[sessionID])!,
                    startTime: row[startTime],
                    endTime: row[endTime],
                    isActive: row[isActive]
                )
            }
        } catch {
            print("Error fetching active session: \(error)")
        }
        return nil
    }

    func endSession(_ session: Session) {
        do {
            try db.run(sessions.filter(sessionID == session.id.uuidString).update(
                isActive <- false,
                endTime <- Date()
            ))
        } catch {
            print("Error ending session: \(error)")
        }
    }

    // MARK: - Block Operations
    func insertBlock(_ block: Block) {
        do {
            try db.run(blocks.insert(
                blockID <- block.id.uuidString,
                blockSessionID <- block.sessionID.uuidString,
                url <- block.url.absoluteString,
                timestamp <- block.timestamp,
                previousHash <- block.previousHash,
                hash <- block.hash
            ))
        } catch {
            print("Error inserting block: \(error)")
        }
    }

    func fetchBlocks(for sessionID: UUID) -> [Block] {
        var blocksArray: [Block] = []
        do {
            for row in try db.prepare(blocks.filter(blockSessionID == sessionID.uuidString)) {
                if let blockURL = URL(string: row[url]) {
                    let block = Block(
                        sessionID: UUID(uuidString: row[blockSessionID])!,
                        url: blockURL,
                        previousHash: row[previousHash]
                    )
                    blocksArray.append(block)
                }
            }
        } catch {
            print("Error fetching blocks: \(error)")
        }
        return blocksArray
    }
}
