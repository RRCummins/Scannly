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
                
                Group {
                    if isConnectedToPeriph {
                        Text("Connected to \(vm.scanner.connectedPeripheral?.name ?? "-")")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            
                    } else {
                        Text("Not Connected")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .background(isConnectedToPeriph ? Color.mint : Color.red)
                .clipShape(Capsule())
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
                
                if let services = connectedItem?.services {
                    List(services, id: \.self) { service in
                        Text("\(service.description)")
                        Text("\(service.uuid.uuidString)")
                        Text("\(service.debugDescription)")
                    }
                    .listStyle(.plain)
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
    
    var isConnectedToPeriph: Bool {
        if vm.scanner.isConnected && vm.scanner.connectedPeripheral == peripheral {
            return true
        } else {
            return false
        }
    }
    
    var connectedItem: PeripheralItem? {
        if vm.scanner.isConnected && vm.scanner.connectedPeripheral == peripheral {
            if let item = vm.scanner.connectedItem {
                return item
            }
            return nil
        }
        return nil
    }
}

//struct PeripheralView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeripheralView(peripheral: CBPeripheral())
//    }
//}
