//
//  Session.swift
//  yt
//
//  Created by Isaac Ramonet on 24/3/25.
//

import Foundation

struct Session: Codable, Identifiable {
    let id: UUID
    let startTime: Date
    let endTime: Date?
    let isActive: Bool

    init(startTime: Date, endTime: Date? = nil, isActive: Bool = true) {
        self.id = UUID()
        self.startTime = startTime
        self.endTime = endTime
        self.isActive = isActive
    }
    
    init(id: UUID, startTime: Date, endTime: Date?, isActive: Bool) {
       self.id = id
       self.startTime = startTime
       self.endTime = endTime
       self.isActive = isActive
    }
}
