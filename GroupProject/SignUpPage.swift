//
//  SignUpPage.swift
//  GroupProject
//
//  Created by Abu Saeed on 16/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SignUpPage: View {
    @State private var email:String = "";
    @State private var pass:String = "";
    @State private var passAgain:String = "";
    
    @State private var alertMessage = "";
    @State private var message = "Create account";
    @State private var showAlert = false;
    
    @State private var isProcessing:Bool = false;
    
    func createAction(){
        if( !pass.elementsEqual(passAgain) ){
            alertMessage = "Password doesn't match";
            showAlert = true;
            return;
        }
        
        if(pass.count < 6){
            alertMessage = "Password too short";
            showAlert = true;
            return;
        }
        
        if(email.isEmpty){
            alertMessage = "Email can't be empty";
            showAlert = true;
            return;
        }
        
        showAlert = false;
        createUserAccount(email: email, pass: pass);
        
    }
    
    func createUserAccount(email:String, pass:String){
        isProcessing = true;
        Auth.auth()
            .createUser(withEmail: email, password: pass){ (result, error) in
                isProcessing = false;
                if error != nil {
                    alertMessage = error?.localizedDescription ?? "";
                    showAlert = true;
                }
                else {
                    message = "Account created successfully"
                }
            }
    }

    var body: some View {
        ZStack{
            VStack{
                
                VStack{
                    Text(message)
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.custom("AmericalTypewriter", fixedSize:24))
                        .padding(8)
                    
                }
                .cornerRadius(12)
                .background(Color.black)
                
                VStack{
                    LottieView(fileName: "sign_up_lottie")
                        .frame(width:250,height:250,alignment: .center)
                }
                
                VStack(alignment:.leading){
                    Text("Email")
                        .frame(minHeight:24)
                        .font(.callout)
                        .padding(4)
                    
                    TextField("Enter email",text:self.$email)
                        .frame(height:48)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal],12)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Text("Password")
                        .frame(minHeight:24)
                        .font(.callout)
                        .padding(4)
                    
                    TextField("Enter password",text:self.$pass)
                        .frame(height:48)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal],12)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
                        )
                    
                    Text("Confirm password")
                        .frame(minHeight:24)
                        .font(.callout)
                        .padding(4)
                    
                    TextField("Enter password again",text:self.$passAgain)
                        .frame(height:48)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal],12)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
                        )
                        
                }//vstack
                .padding(12)
                if showAlert{
                    VStack(alignment: .center){
                        Text(alertMessage)
                            .font(.system(size: 10))
                            .foregroundColor(Color.red)
                            .frame(maxWidth:.infinity,alignment: .leading)
                    }
                    .padding(EdgeInsets(
                            top:-4,
                            leading: 20,
                            bottom: 0,
                            trailing: 0
                        )
                    )
                } // if of showAlert
                
                VStack{
                    Button(action: createAction, label: {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(minWidth:0,maxWidth: .infinity)
                            .padding()
                    })
                    .foregroundColor(.white)
                    .background(Color.orange)
                    .cornerRadius(32)
                    .padding([.horizontal],64)

                }//vstack
                .padding([.horizontal],12)
                
                Spacer()
            }//Vstack
        
            if(isProcessing){
                
                VStack{
                    
                    LottieView(fileName:"lottie_progress")
                        .frame(width:150,height:150,alignment: .center)
                    
                }//vstack
                .padding(24)
                .cornerRadius(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray)
                )
                
            }//if-is-processing
        }//vstack
        
    }//body
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}

