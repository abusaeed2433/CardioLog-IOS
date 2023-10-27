//
//  OTPPage.swift
//  GroupProject
//
//  Created by Abu Saeed on 8/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct OTPPage: View {
    @State private var email:String = "";
    @State private var alertMessage:String = "";
    @State private var showAlert = false;
    @State private var message = "Reset password"
    
    func forgotRequest(){
        if(email.isEmpty){
            alertMessage = "Can't be empty";
            showAlert = true;
            return
        }
        
        showAlert = false;
        
        Auth.auth().sendPasswordReset(withEmail: email){ error in
                if error != nil {
                    alertMessage = error?.localizedDescription ?? "";
                    showAlert = true;
                }
                else {
                    message = "Reset link is sent successfully"
                }
        }
        
    }
    
    var body: some View {
        VStack{
            VStack{
                
                Spacer()
                
                VStack{
                    Text(message)
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.custom("AmericalTypewriter", fixedSize:24))
                        .padding(8)
                    
                }
                .cornerRadius(12)
                .background(Color.black)
                
                Spacer()
                
                VStack(alignment:.leading){
                    HStack(alignment:.center){
                        VStack{
                            LottieView(fileName: "forgot_lottie")
                                .frame(width:.infinity,height:250,alignment: .center)
                        }
                    }//hstack
                    .frame(minWidth:0, maxWidth: .infinity)
                    
                    Text("Enter your email and request reset link")
                        .frame(minWidth:0,maxWidth: .infinity,minHeight: 48)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(4)
                    
                    TextField("email",text:self.$email)
                        .frame(height:48)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal],12)
                        .cornerRadius(8)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
                        )
                        .padding([.horizontal],24)
                }//Vstack
                .padding(12)
                
                if(showAlert){
                    VStack(alignment:.center){
                        Text(alertMessage)
                            .font(.system(size: 10))
                            .foregroundColor(Color.red)
                            .frame(maxWidth:.infinity,alignment: .leading)
                    }//vstack
                    .padding(
                        EdgeInsets(
                            top: -4, leading: 20, bottom: 0, trailing: 0
                        )
                    )
                }//if end
                
                Spacer(minLength: 0)
                
                Button(action:forgotRequest,label:{
                    Text("Request reset")
                        .fontWeight(.semibold)
                        .frame(minWidth:0,maxWidth: .infinity)
                        .padding(.vertical,16)
                })
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(32)
                .padding([.horizontal],32)
                
                Spacer()
                
            }//Vstack
        }
        //.navigationBarTitle("Go Back")
    }
}

struct OTPPage_Previews: PreviewProvider {
    static var previews: some View {
        OTPPage()
    }
}
