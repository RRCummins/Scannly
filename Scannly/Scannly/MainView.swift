//
//  MainView.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import CoreBluetooth
import SwiftUI

struct MainView: View {
    @ObservedObject var vm = ViewModel()
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack {
                    Text("Bluetooth Scanner")
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .foregroundStyle(.linearGradient(Gradient(colors: vm.gradientColors), startPoint: .leading, endPoint: .trailing))
                        .padding()
                    PingView(isAnimating: isAnimating)
                        .frame(width: 50, height: 50, alignment: .trailing)
                        .opacity(isAnimating ? 1 : 0)
                }
                List {
                    Section("Favorites") {
                        ForEach(vm.favorites) { favorite in
                            NavigationLink {
                                if let result = vm.linkedItem(peri: favorite) {
                                    PeripheralView(peripheral: result, vm: PeripheralView.ViewModel(scanner: vm.scanner))
                                } else {
                                    FavoriteView(peripheral: favorite)
                                }
                            } label: {
                                Text(favorite.name)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    vm.unFavoritePeripheral(peri: favorite)
                                } label: {
                                    Label("Unfavorite", systemImage: "star.slash")
                                }
                            }
                        }
                    }
                    Section("Discovered") {
                        ForEach(vm.scanner.peripherals, id: \.self) { peripheral in
                            NavigationLink {
                                PeripheralView(peripheral: peripheral.item, vm: PeripheralView.ViewModel(scanner: vm.scanner))
                            } label: {
                                Text(peripheral.item.name ?? "Unnamed")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    withAnimation {
                                        vm.favoritePeripheral(cbp: peripheral.item)
                                    }
                                } label: {
                                    Label("Favorite", systemImage: "star")
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
                        if isScanning {
                            withAnimation {
                                vm.stop()
                                isAnimating = false
                            }
                        } else {
                            withAnimation {
                                vm.start()
                                isAnimating = true
                            }
                        }
                    } label: {
                        if isScanning {
                            Label("Stop Scanning", systemImage: "stop.circle")
                        } else {
                            Label("Start Scanning", systemImage: "play.circle")
                        }
                        
                    }
                    .foregroundColor(.mint)

                    Button {
                        withAnimation {
                            vm.isShowingSheet = true
                        }
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up.circle")
                    }
                    .foregroundColor(.mint)
                }
            }
            .sheet(isPresented: $vm.isShowingSheet,
                           content: {
                ShareSheet(activityItems: [vm.shareText(prettyPrinted: true)] as [String], applicationActivities: nil) })
        }
    }
    
    var isScanning: Bool {
        if vm.isScanning {
            return true
        } else {
            return false
        }
        return false
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
