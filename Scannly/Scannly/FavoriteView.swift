//
//  FavoriteView.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import SwiftUI

struct FavoriteView: View {
    var peripheral: Peripheral
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(peripheral.name )
                .font(.title)
                .padding()
            Text("Identifier")
                .font(.headline)
            Text(peripheral.id.uuidString)
                .font(.subheadline)
                .padding()
            Text("Description")
                .font(.headline)
            Text(peripheral.description)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle(peripheral.name)
    }
}

//struct FavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteView()
//    }
//}
