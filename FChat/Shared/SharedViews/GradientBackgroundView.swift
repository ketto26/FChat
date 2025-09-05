//
//  GradientBackgroundView.swift
//  FChat
//
//  Created by Keto Nioradze on 01.09.25.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        
        ZStack{
            LinearGradient(colors: [ Color(hex: "#f3f1fc"), Color(hex: "#745ddd"), Color(hex: "#e480f2"),], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
        }
        .overlay(Color.white.opacity(0.3))
       // .blur(radius: 50)
        .ignoresSafeArea()
    }
}

struct GradienTBackgroundModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .background{
                GradientBackgroundView()
            }
    }
}

extension View{
    func gradientBackground() -> some View{
        self.modifier(GradienTBackgroundModifier())
    }
}

#Preview {
    GradientBackgroundView()
}
