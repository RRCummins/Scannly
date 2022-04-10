//
//  MainView-ViewModel.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import Combine
import CoreBluetooth
import SwiftUI

extension MainView {
    class ViewModel: ObservableObject {
        @Published var scanner: BTScanner
        @Published private(set) var favorites: [Peripheral]
        @Published var isScanning: Bool
        
        var anyCancellable: AnyCancellable? = nil
        
        init() {
            scanner = BTScanner()
            favorites = DataManager.loadItems()
            isScanning = false
            
            // This notifies the view that the child class's property has changed when it calls objectWillChange.send()
            anyCancellable = scanner.objectWillChange.sink { [weak self] (_) in
                        self?.objectWillChange.send()
                    }
        }
        
        var gradientColors: [Color] {
            if isScanning {
                return [Color.indigo, Color.mint]
            } else {
                return [Color.red, Color.blue]
            }
        }
        

        func start() {
            scanner.startScanning()
            isScanning = true
        }
        
        func stop() {
            scanner.stopScanning()
            isScanning = false
        }
        
        func favoritePeripheral(cbp: CBPeripheral) {
            if !favorites.contains(where: {$0.id == cbp.identifier }) {
                withAnimation {
                    favorites.append(Peripheral(id: cbp.identifier, name: cbp.name ?? "-", description: cbp.description))
                }
                DataManager.saveItems(favorites)
            }
        }
        
        func unFavoritePeripheral(peri: Peripheral) {
            withAnimation {
                favorites.removeAll(where: { $0.id == peri.id })
            }
            DataManager.saveItems(favorites)
        }
        
        func linkedItem(peri: Peripheral) -> CBPeripheral? {
            if let result = scanner.peripherals.first(where: { $0.identifier == peri.id }) {
                return result
            }
            return nil
        }
        
    }
}
