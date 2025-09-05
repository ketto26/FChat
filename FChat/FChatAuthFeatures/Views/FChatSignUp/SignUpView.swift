//
//  SignUpView.swift
//  FChat
//
//  Created by Keto Nioradze on 01.09.25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ScrollView() {
            
            VStack(spacing: 40) {
                Text("Create your account")
                    .font(.title.weight(.bold))
                    .padding(.bottom)
                
                VStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 40) {
                        TextField("Email", text: $authVM.state.email)
                            .frame(height: 40)
                            .background(.clear)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $authVM.state.password)
                            .frame(height: 40)
                            .background(.clear)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black)
                            )
                    }
                    
                    Spacer()
                    
                    Text("By creating an account or continue with Google you agree to our Terms and Conditions and Privacy Policy")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                    
                    Button("Sign Up") {
                        Task {
                            await authVM.signUp()
                            if authVM.state.isSignedIn {
                                coordinator.popToRoot()
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(20)
                    
                    
                    //NavigationLink("home", destination: HomeScreenView())
                }
                
                HStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 1)
                    
                    Text("or")
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 1)
                }
                
                
                Button(action: {
                    Task {
                        await authVM.signInWithGoogle()
                    }
                }) {
                    HStack {
                        Image("Google")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("Sign in with Google")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black))
                }
                .disabled(authVM.state.isLoading)
                
                HStack {
                    Text("Already have an account?")
                    Button("Sing in"){
                        coordinator.navigate(to: .login)
                    }
                   // .foregroundStyle(.white)
                }
                
            }
            .foregroundStyle(.black)
            .padding(.horizontal)
        }
        .defaultScrollAnchor(.center, for: .alignment)
        
        .gradientBackground()
        .padding(0)
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
        .environmentObject(Coordinator())
}
