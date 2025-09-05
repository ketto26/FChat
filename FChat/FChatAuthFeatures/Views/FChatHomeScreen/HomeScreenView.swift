//
//  HomeScreenView.swift
//  FChat
//
//  Created by Keto Nioradze on 01.09.25.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack{
            Text("FChat")
                .font(.largeTitle)
            
            Text("Chatting Main Screen")
            
            Button("Sign Out") {
                authVM.signOut()
            }
            .buttonStyle(.bordered)
        }
        .navigationBarBackButtonHidden(true) 
    }
}

#Preview {
    // FIX: Provide the required environment objects for the preview
    // Note: It's good practice to pre-populate the state for previews.
    let authVM = AuthViewModel()
    authVM.state.user = ChatUser(id: "preview_user", email: "preview@example.com")
    
    return HomeScreenView()
        .environmentObject(authVM)
        .environmentObject(Coordinator())
}
