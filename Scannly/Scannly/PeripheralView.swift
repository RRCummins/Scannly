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
            Text(peripheral.name ?? "Fount Item")
                .font(.title)
                .padding()
            Text("Identifier")
                .font(.headline)
            Text(peripheral.identifier.uuidString)
                .font(.subheadline)
                .padding()
            Text("Description")
                .font(.headline)
            Text(peripheral.description)
                .padding()
            Text("State")
                .font(.headline)
            Text("\(peripheral.state.rawValue)")
                .padding()
            Text("Services")
                .font(.headline)
            if let services = peripheral.services {
                List(services, id: \.self) { service in
                    Text("\(service.uuid.uuidString)")
                }
                .padding()
            } else {
                Text("No Services Found")
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitle(peripheral.name ?? "Bluetooth Item")
    }
}

//struct PeripheralView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeripheralView(peripheral: CBPeripheral())
//    }
//}
