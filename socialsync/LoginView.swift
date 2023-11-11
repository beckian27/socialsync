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
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    TextField("username", text: $user)
                    TextField("password", text: $password)
                    Button("Login") {Config.logged_in = true; Config.username = user; dismiss(); dismiss()}
                    Button("Create Account") {
                    let _: [String] = apipost(endpoint: "create_user/", parameters: ["username": user, "fullname": user, "filename": user, "password": password])
                        Config.logged_in = true; Config.username = user; dismiss(); dismiss()
                    }
                    
                }
                
            }
//            .navigationDestination(isPresented: $logged_in) {
//                ContentView()
//                    .navigationBarHidden(false)
//                    .navigationBarTitleDisplayMode(.inline)
//            }
            

        }
//        .task{
//            logged_in = Config.logged_in
//        }
    }
}
    


#Preview {
    LoginView()
}
