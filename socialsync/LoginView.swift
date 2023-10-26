//
//  LoginView.swift
//  socialsync
//
//  Created by Ian Beck on 10/13/23.
//

import SwiftUI

struct LoginView: View {
    @State private var logged_in: Bool = Config.logged_in
    @State private var user: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("username", text: $user)
                TextField("password", text: $user)
                Button("Login") {logged_in = true}
                Button("Create Account") {print("hi")}
                
            }
            .navigationDestination(isPresented: $logged_in) {
                ContentView()
            }
        }
    }
}
    


#Preview {
    LoginView()
}
