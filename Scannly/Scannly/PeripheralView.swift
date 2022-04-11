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
    var vm: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                if vm.scanner.isConnected {
                    Text("Connected to \(vm.scanner.connectedPeripheral?.name ?? "-")")
                        .font(.headline)
                        .foregroundColor(.green)
                } else {
                    Text("Not Connected")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            VStack(alignment: .leading) {
                Text(peripheral.name ?? "Found Item")
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
        }
        .navigationBarTitle(peripheral.name ?? "Bluetooth Item")
        .toolbar {
            ToolbarItem {
                Button {
                    if vm.scanner.isConnected {
                        vm.disconnect(peripheral: peripheral)
                    } else {
                        vm.connectTo(peripheral: peripheral)
                    }
                } label: {
                    if vm.scanner.isConnected {
                        Text("Disconnect")
                    } else {
                        Text("Connect")
                    }
                }
            }
        }
    }
}

//struct PeripheralView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeripheralView(peripheral: CBPeripheral())
//    }
//}
