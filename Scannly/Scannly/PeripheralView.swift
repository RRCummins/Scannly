//
//  PeripheralView.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import CoreBluetooth
import SwiftUI

struct PeripheralView: View {
    var peripheral: CBPeripheral
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(peripheral.name ?? "-")
                .font(.headline)
                .padding()
            Text(peripheral.identifier.uuidString)
                .font(.subheadline)
                .padding()
            Text(peripheral.description)
                .padding()
        }
        .navigationBarTitle(peripheral.name ?? "BlueTooth Item")
    }
}

//struct PeripheralView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeripheralView(peripheral: CBPeripheral())
//    }
//}
