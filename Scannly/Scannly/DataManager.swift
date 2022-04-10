//
//  DataManager.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import CoreBluetooth
import Foundation
import SwiftUI

struct DataManager{
    enum DataVersion: String  {
        case itemDataV1 = "itemDataV1"
    }
    
    static let savePath = FileManager.documentsDirectory.appendingPathComponent(DataVersion.itemDataV1.rawValue)
    
    static func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    static func loadItems() -> [Peripheral] {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Peripheral].self, from: data) {
                print(decoded)
                return decoded
            }
        }
        return [Peripheral]()
    }
    
    static func saveItems(_ items: [Peripheral]) {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print(data)
        }
    }
    
}
