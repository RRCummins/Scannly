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
    
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Bluetooth Scanner")
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundStyle(.linearGradient(Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing))
                    .padding()
                VStack {
                    List(scanner.peripherals, id: \.self) { peri in
                        NavigationLink {
                            PeripheralView(peripheral: peri)
                        } label: {
                            Text(peri.name ?? "Unnamed")
                        }
                    }
                    .listStyle(.insetGrouped)
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
