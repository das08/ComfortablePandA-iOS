//
//  LoginTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/08.
//

import SwiftUI


struct LoginView: View {
    @State private var ECS_ID: String = ""
    @State private var Password: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("PandA Login")
                    .font(.system(size: 48,
                                  weight: .heavy))
                
                VStack(spacing: 24) {
                    TextField("ECS_ID", text: $ECS_ID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    
                    SecureField("Password", text: $Password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    
                }
                .frame(height: 200)
                
                Button(action: {
                    //                       print("Login処理\(ECS_ID)")
                    //                        let res = getKeychain(account: "ECS_ID")
                    let saveECS_ID = saveKeychain(account: "ECS_ID", value: ECS_ID)
                    //                        print("Login処理\(Password)")
                    //                        let res = getKeychain(account: "Password")
                    let savePassword = saveKeychain(account: "Password", value: Password)
                    //                        print("get: \(res.success)")
                    //                        print("get: \(res.data)")
                    //                        print("save: \(s.success)")
                    
                },
                label: {
                    Text("ログイン")
                        .fontWeight(.medium)
                        .frame(minWidth: 160)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                })
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
