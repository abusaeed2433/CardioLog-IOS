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
    
    @State private var showAlert:Bool = false;
    
    @State private var isAlert:Bool = false;
    @State private var message:String?;
    
    @Environment(\.presentationMode) var presentationMode
    
    
    func forgotRequest(){
        if(email.isEmpty){
            alertMessage = "Can't be empty";
            showAlert = true;
            return
        }
        
        showAlert = false;
        
        Auth.auth().sendPasswordReset(withEmail: email){ error in
                if error != nil {
                    message = error?.localizedDescription ?? "";
                    isAlert = true;
                    showAlert = true;
                }
                else {
                    message = "Reset link is sent successfully"
                    isAlert = false;
                }
        }
        
    }
    
    private func onErrorDismissed(){
        
        if( message == "Reset link is sent successfully" ){
            presentationMode.wrappedValue.dismiss(); // back to LoginPage
        }
        
        message = nil;
        isAlert = false;
    }
    
    
    var body: some View {
        
        ZStack{
        
            VStack{
                VStack{
                    
                    Spacer()
                    
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
                        
                        TextField("Email",text:self.$email)
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
                    .padding([.horizontal],12)
                    
                    if(showAlert){
                        VStack(alignment:.center){
                            Text(alertMessage)
                                .font(.system(size: 12))
                                .foregroundColor(Color.red)
                                .frame(maxWidth:.infinity,alignment: .leading)
                        }//vstack
                        .padding([.horizontal],40)
                        .padding(.top,-4)
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
        
            
            if(message != nil){
                VStack{
                    Spacer()
                    GeometryReader{ gm in
                        VStack{
                            Spacer()
                            VStack{
                                
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width:32,height:32)
                                    .foregroundColor(.black)
                                    .padding(12)

                                Text(message ?? "none")
                                    .frame(minHeight:18)
                                    .font(.custom("AmericanTypewriter", fixedSize:20) )
                                    .foregroundColor( isAlert ? Color.red : Color.black)
                                    .padding(.bottom,16)
                                    .frame(minWidth:0,maxWidth: .infinity)
                            
                                HStack{
                                    Button(action: onErrorDismissed, label: {
                                        Text("OK")
                                            .fontWeight(.semibold)
                                            .padding(10)
                                    })
                                    .foregroundColor(.white)
                                    .frame(width: gm.size.width * 0.6)
                                    .background(isAlert ? Color.orange : Color.green)
                                    .cornerRadius(24)
                                    .padding([.horizontal],8)
                                }//hstack
                            }//vstack
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            Spacer()
                            
                        }//vstack
                    }//geometry
                    
                    Spacer()
                    
                }//vstack
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                .padding(36)
                .background(Color.black.opacity(0.1))
                
            }//if- alert
            
        }
    }
}

struct OTPPage_Previews: PreviewProvider {
    static var previews: some View {
        OTPPage()
    }
}
