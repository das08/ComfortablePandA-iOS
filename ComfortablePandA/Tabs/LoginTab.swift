//
//  LoginTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/08.
//

import SwiftUI

struct LoginView: View {
    @State var showingAlert = false
    @State var alertText = ""
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
                    UIApplication.shared.endEditing()
                    if ECS_ID == "" || Password == "" {
                        self.showingAlert = true
                        self.alertText = ErrorMsg.EmptyIDAndPass.rawValue
                    }else{
                        self.showingAlert = true
                        
                        _ = saveKeychain(account: "ECS_ID", value: ECS_ID)
                        _ = saveKeychain(account: "Password", value: Password)
                        let loginRes = SakaiAPI.shared.login()

                        if loginRes.success {
                            self.alertText = "ECS_ID, パスワードを保存しました。"
                        }else{
                            if loginRes.error == Login.Network {
                                self.alertText = ErrorMsg.FailedToGetResponse.rawValue
                            }else{
                                self.alertText = loginRes.errorMsg
                            }
                        }
                    }
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
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("\(alertText)"))
                }
                Spacer()
            }
        }.onTapGesture {
            hideKeyboard()
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
