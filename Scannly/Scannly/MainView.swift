//
//  MainView.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import CoreBluetooth
import SwiftUI

struct MainView: View {
    @ObservedObject var scanner = BTScanner()
    
    @State private var favorites = [Peripheral]()
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Bluetooth Scanner")
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundStyle(.linearGradient(Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing))
                    .padding()
                List {
                    Section("Favorites") {
                        ForEach(favorites) { favorite in
                            NavigationLink {
                                if let result = linkedItem(peri: favorite) {
                                    PeripheralView(peripheral: result)
                                } else {
                                    FavoriteView(peripheral: favorite)
                                }
                            } label: {
                                Text(favorite.name)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    unFavoritePeripheral(peri: favorite)
                                } label: {
                                    Label("Unfavorite", image: "star.slash")
                                }
                            }
                        }
                    }
                    Section("Discovered") {
                        ForEach(scanner.peripherals, id: \.self) { peripheral in
                            NavigationLink {
                                PeripheralView(peripheral: peripheral)
                            } label: {
                                Text(peripheral.name ?? "Unnamed")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    withAnimation {
                                        favoritePeripheral(cbp: peripheral)
                                    }
                                } label: {
                                    Label("Favorite", image: "star")
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.init(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            scanner.startScanning()
                            isScanning = true
                        }
                    } label: {
                        Text("Scan")
                    }
                    
                    Button {
                        withAnimation {
                            scanner.stopScanning()
                            isScanning = false
                        }
                    } label: {
                        Text("Stop")
                    }
                    
                }
            }
        }
    }
    
    var gradientColors: [Color] {
        if isScanning {
            return [Color.indigo, Color.mint]
        } else {
            return [Color.red, Color.blue]
        }
    }
    
    func favoritePeripheral(cbp: CBPeripheral) {
        if !favorites.contains(where: {$0.id == cbp.identifier }) {
            withAnimation {
                favorites.append(Peripheral(id: cbp.identifier, name: cbp.name ?? "-", description: cbp.description))
            }
        }
    }
    
    func unFavoritePeripheral(peri: Peripheral) {
        withAnimation {
            favorites.removeAll(where: { $0.id == peri.id })
        }
    }
    
    func linkedItem(peri: Peripheral) -> CBPeripheral? {
        if let result = scanner.peripherals.first(where: { $0.identifier == peri.id }) {
            return result
        }
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
