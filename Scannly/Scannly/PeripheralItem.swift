//
//  PeripheralItem.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/11/22.
//

import Foundation
import CoreBluetooth

struct PeripheralItem: Hashable, Identifiable {
    var id = UUID()
    var item: CBPeripheral
    var services = [CBService]()
}
