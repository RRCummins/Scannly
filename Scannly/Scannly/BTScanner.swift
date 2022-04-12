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

class BTScanner: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var didChange = PassthroughSubject<Void, Never>()
    var centralManager: CBCentralManager?
    @Published var peripherals: [PeripheralItem] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var connectedItem: PeripheralItem?
    @Published var isConnected = false
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    var services: [CBService] = []
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager()
        centralManager?.delegate = self
        
        peripherals = []
    }
    
    deinit {
        centralManager?.stopScan()
    }
    
    func connectTo(peripheral: CBPeripheral) {
        print("Attempting to connect to \(peripheral.name ?? "Unknown")")
        centralManager?.connect(peripheral)
    }
    
    func disconnectFrom(peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        objectWillChange.send()

        self.peripherals.append(PeripheralItem(item: peripheral))
        peripheral.delegate = self
        print("Found - \(peripheral.name ?? "")")
        didChange.send(())
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        self.peripherals.append(peripheral)
        objectWillChange.send()
        isConnected = true
        connectedPeripheral = peripheral
        connectedItem = PeripheralItem(item: peripheral)
        print("Connected to - \(peripheral.name ?? "")")
//        peripheral.discoverServices([heartRateServiceCBUUID])
        discoverServices(peripheral: peripheral)
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
    
    func scanForHeart() {
        if centralManager?.state == .poweredOn {
            peripherals = []
            centralManager?.scanForPeripherals(withServices: [heartRateServiceCBUUID], options: nil)
            print("Start Scanning for HeartRate Devices")
        } else {
            print("Error - centralManager not poweredOn")
        }
    }
    
    func stopScanning() {
        centralManager?.stopScan()
        print("Stop Scanning")
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        objectWillChange.send()
        isConnected = true
        connectedPeripheral = peripheral
        print("Connected to \(peripheral.name ?? "Unknown")")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        objectWillChange.send()
        //
        print("Failed to connect \(error.debugDescription)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        objectWillChange.send()
        isConnected = false
        connectedPeripheral = nil
        print("Disconnected \(error.debugDescription)")
    }
    
    //MARK: - Services & Characteristics
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
          print(service)
            connectedItem?.services.append(service)
        }
    }
     
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else {
//            return
//        }
//        if let services = peripheral.services {
//            for service in services {
//                print("Found service - \(service)")
//            }
//        }
//
//        discoverCharacteristics(peripheral: peripheral)
//        if let itemIndex = peripherals.firstIndex(where: { $0.item.identifier == peripheral.identifier }) {
//            peripherals[itemIndex].services = services
//        }
//    }
     
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
//        if let itemIndex = peripherals.firstIndex(where: { $0.item.identifier == peripheral.identifier }) {
//            peripherals[itemIndex].services.append(service)
//        }
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

