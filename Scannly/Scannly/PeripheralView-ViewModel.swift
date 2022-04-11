//
//  PeripheralView-ViewModel.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/11/22.
//

import CoreBluetooth
import SwiftUI

extension PeripheralView {
    class ViewModel {
        @Published var scanner: BTScanner
        
        init(scanner: BTScanner) {
            self.scanner = scanner
        }
        
        func connectTo(peripheral: CBPeripheral) {
            print("Attempting to connect to \(peripheral.name ?? "Unknown")")
            scanner.connectTo(peripheral: peripheral)
        }
        
        func disconnect(peripheral: CBPeripheral) {
            scanner.disconnectFrom(peripheral: peripheral)
        }
    }
}
