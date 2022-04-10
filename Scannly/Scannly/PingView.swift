//
//  PingView.swift
//  Scannly
//
//  Created by Ryan Cummins on 4/10/22.
//

import SwiftUI

struct PingView: View {
    var isAnimating: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .scale(isAnimating ? 1.5 : 0)
                .opacity(isAnimating ? 0 : 1.0)
                .offset(x: isAnimating ? 300 : 0, y: 0)
                .foregroundColor(isAnimating ? .mint : .indigo)
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            Circle()
                .scale(isAnimating ? 1.0 : 0)
                .opacity(isAnimating ? 0 : 1.0)
                .offset(x: isAnimating ? 300 : 0, y: 0)
                .foregroundColor(isAnimating ? .indigo : .mint)
                .animation(.linear(duration: 1).delay(0.5).repeatForever(autoreverses: false), value: isAnimating)
        }
    }
}

struct PingView_Previews: PreviewProvider {
    static var previews: some View {
        PingView(isAnimating: false)
    }
}
