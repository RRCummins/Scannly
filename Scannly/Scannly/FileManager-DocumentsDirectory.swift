//
//  FileManager-DocumentsDirectory.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
