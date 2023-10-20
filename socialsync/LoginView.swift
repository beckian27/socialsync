//
//  LoginView.swift
//  socialsync
//
//  Created by Ian Beck on 10/13/23.
//

import SwiftUI

struct LoginView: View {
    @State private var user: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                TextField("username", text: $user)
                TextField("password", text: $user)
                Button("Login") {}
                Button("Create Account") {}
                
            }
        }
    }
}


#Preview {
    LoginView()
}
