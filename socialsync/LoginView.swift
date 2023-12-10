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
    @Environment(\.presentationMode) var loginMode
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    TextField("username", text: $user)
                    TextField("password", text: $password)
                    Button("Login") {
                        if !user.isEmpty && !password.isEmpty {Config.logged_in = true; Config.username = user; loginMode.wrappedValue.dismiss()}}//dismiss(); dismiss()}
                    Button("Create Account") {
                        if !user.isEmpty && !password.isEmpty {
                            let _: [String] = apipost(endpoint: "create_user/", parameters: ["username": user, "fullname": user, "filename": user, "password": password])
                            Config.logged_in = true; Config.username = user; dismiss(); dismiss()}
                    }
                }
            }
        }
    }
}
    


#Preview {
    LoginView()
}
