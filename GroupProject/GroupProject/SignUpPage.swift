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
    
    @State private var alertMessage:String?
    @State private var message:String?
    @State private var showAlert = false;
    
    @State private var isProcessing:Bool = false;
    @State private var isAlert:Bool = false;
    
    @Environment(\.presentationMode) var presentationMode
    
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
    
    private func onErrorDismissed(){
        
        if( message == "Account created successfully" ){
            presentationMode.wrappedValue.dismiss(); // back to LoginPage
        }
        
        message = nil;
        isAlert = false;
    }
    
    func createUserAccount(email:String, pass:String){
        isProcessing = true;
        Auth.auth()
            .createUser(withEmail: email, password: pass){ (result, error) in
                isProcessing = false;
                if error != nil {
                    isAlert = true;
                    message = error?.localizedDescription ?? "";
                    //showAlert = true;
                }
                else {
                    isAlert = false;
                    message = "Account created successfully"
                }
            }
    }

    var body: some View {
        ZStack{
            VStack{
                /*
                VStack{
                    Text(message)
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.custom("AmericalTypewriter", fixedSize:24))
                        .padding(8)
                    
                }
                .cornerRadius(12)
                .background(Color.black)
 */
                
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
                        .autocapitalization(.none)
                    
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
                        .autocapitalization(.none)
                    
                }//vstack
                .padding(12)
                
                if showAlert{
                    VStack(alignment: .center){
                        Text(alertMessage!)
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
/*                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray)
                )
*/
            }//if-is-processing
            
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
            
        }//vstack
        
    }//body
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}

