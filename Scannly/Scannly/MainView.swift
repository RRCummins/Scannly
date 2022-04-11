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
                                    Label("Unfavorite", image: "star.slash")
                                }
                            }
                        }
                    }
                    Section("Discovered") {
                        ForEach(vm.scanner.peripherals, id: \.self) { peripheral in
                            NavigationLink {
                                PeripheralView(peripheral: peripheral, vm: PeripheralView.ViewModel(scanner: vm.scanner))
                            } label: {
                                Text(peripheral.name ?? "Unnamed")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    withAnimation {
                                        vm.favoritePeripheral(cbp: peripheral)
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
                            vm.start()
                            isAnimating = true
                        }
                    } label: {
                        Text("Scan")
                    }
                    Button {
                        withAnimation {
                            vm.stop()
                            isAnimating = false
                        }
                    } label: {
                        Text("Stop")
                    }
                    Button {
                        withAnimation {
                            vm.isShowingSheet = true
                        }
                    } label: {
                        Text("Share")
                    }
                }
            }
            .sheet(isPresented: $vm.isShowingSheet,
                           content: {
                ShareSheet(activityItems: [vm.shareText(prettyPrinted: true)] as [String], applicationActivities: nil) })
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
