//
//  Peripheral.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import Foundation

struct Peripheral: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    
}
