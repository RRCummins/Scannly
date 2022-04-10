//
//  ContentView.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import CoreBluetooth
import SwiftUI

struct ContentView: View {
    @ObservedObject var scanner = BTScanner()
    
    @State private var favorites = [CBPeripheral]()
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
                        ForEach(favorites, id: \.self) { favorite in
                            NavigationLink {
                                PeripheralView(peripheral: favorite)
                            } label: {
                                Text(favorite.name ?? "Unnamed")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    withAnimation {
                                        favorites.removeAll(where: {$0 == favorite})
                                    }
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
                                        favorites.append(peripheral)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
