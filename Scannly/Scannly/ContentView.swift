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
    
    var body: some View {
        NavigationView {
            VStack {
                List(scanner.peripherals, id: \.self) { peri in
                    NavigationLink {
                        PeripheralView(peripheral: peri)
                    } label: {
                        Text(peri.name ?? "Unnamed")
                    }

                }
                .listStyle(.insetGrouped)
                .background(Color.gray.opacity(0.5))
            }
            .navigationTitle("Bluetooth Scanner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
