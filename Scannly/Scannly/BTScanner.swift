//
//  BTScanner.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import Combine
import CoreBluetooth
import CoreLocation
import Foundation

class BTScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
    var didChange = PassthroughSubject<Void, Never>()
    var centralManager: CBCentralManager?
    @Published var peripherals: [CBPeripheral] = []
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager()
        centralManager?.delegate = self
        peripherals = []
    }
    
    deinit {
        centralManager?.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripherals.append(peripheral)
        print("Found - \(peripheral.name ?? "")")
        didChange.send(())
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        self.peripherals.append(peripheral)
        print("Connected to - \(peripheral.name ?? "")")
        didChange.send(())
    }
    
    func startScanning() {
        if centralManager?.state == .poweredOn {
            peripherals = []
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            print("Start Scanning")
        } else {
            print("Error - centralManager not poweredOn")
        }

    }
    
    func stopScanning() {
        centralManager?.stopScan()
        print("Stop Scanning")
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
//            startScanning()
        @unknown default:
            fatalError()
        }
    }
}

