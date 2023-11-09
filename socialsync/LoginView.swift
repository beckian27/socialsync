//
//  LoginView.swift
//  socialsync
//
//  Created by Ian Beck on 10/13/23.
//

import SwiftUI

struct LoginView: View {
    @State private var logged_in: Bool = false
    @State private var user: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    TextField("username", text: $user)
                    TextField("password", text: $user)
                    Button("Login") {logged_in = true}
                    Button("Create Account") {}
                    
                }
                
            }
            .navigationDestination(isPresented: $logged_in) {
                ContentView()
                    .navigationBarHidden(false)
                    .navigationBarTitleDisplayMode(.inline)
            }
            

        }
        .task{
            logged_in = Config.logged_in
        }
    }
}
    


#Preview {
    LoginView()
}
