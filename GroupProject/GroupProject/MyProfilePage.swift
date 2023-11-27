//
//  MyProfilePage.swift
//  GroupProject
//
//  Created by kuet on 23/11/23.
//

import SwiftUI
import Firebase

struct MyProfilePage: View {
    
    
    @State private var name = "";
    @State private var phone = "";
    @State private var age = ""
    @State private var weight = ""
    @State private var extra = "";
    
    
    @State private var alertMessage:String? = nil;
    @State private var isAlert = false;
    
    let ref = Database.database().reference()
    @Environment(\.presentationMode) var presentationMode
    @State var allDisabled:Bool = false
    
    private func fetchMyData(){
        
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        let myRef = Database.database().reference().child("users").child(uid!);
        
        
        myRef.observeSingleEvent(of: .value){ snapshot in
            
            if(snapshot.exists()){
                
                let data = snapshot.value as! [String:Any];
                
                name = data["name"]! as! String
                phone = data["phone"]! as! String
                age = data["age"]! as! String
                weight = data["weight"]! as! String
                extra = data["extra"]! as! String
                
            }
            
        };
        
    }

    
    private func onErrorDismissed(){
        
        if( alertMessage == "Data updated successfully" ){
            presentationMode.wrappedValue.dismiss(); // back to showdetails
        }
        
        alertMessage = nil;
        isAlert = false;
    }
    
    func saveAction(){
            
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        
        //let age:Int = Int(age) ?? 0;
        //let weight:Int = Int(weight) ?? 0;
            
        let map:Any = [
            "name": name,
            "phone": phone,
            "age": age,
            "weight": weight,
            "extra": extra
        ]
        
        
        print(map);
        ref.child("users").child(uid!).setValue(map) {(error,reference) in
                
                if let err = error {
                    alertMessage = "Data could not be saved. Because:  \(err.localizedDescription)";
                    isAlert = true;
                    
                }
                else {
                    // check before changing
                    alertMessage = "Data updated successfully";
                    isAlert = false;
                }
        }
        
        print("Save action clicked");
    
    }
    
    
    var body: some View {
        ZStack{
            
            VStack{
                Spacer()
                ScrollView{
                    VStack(spacing:4){
                        
                        //name
                        VStack(alignment:.leading,spacing:4){
                            VStack{
                                LottieView(fileName:"profile_lottie")
                                    .frame(width:100,height:100,alignment: .center)
                            }
                         
                        }//vstack
                        .padding(8)
                        
                        
                        //name
                        VStack(alignment:.leading,spacing:4){
                            
                                TextField("Enter your name",text:self.$name)
                                    .frame(height:48)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal],12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth:1)
                                            .stroke( Color.gray )
                                    )
                                    .foregroundColor(.black)
                         
                        }//vstack
                        .padding(8)
                        
                        //phone
                        VStack(alignment:.leading,spacing:4){
                            
                                TextField("Enter phone no",text:self.$phone)
                                    .frame(height:48)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal],12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth:1)
                                            .stroke( Color.gray )
                                    )
                                    .foregroundColor(.black)
                            
                        }//vstack
                        .padding(8)
                        
                        //sys pressure
                        VStack(alignment:.leading,spacing:4){
                            TextField("Enter age",text:self.$age,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.age = self.age.filter {    $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth:1)
                                        .stroke( Color.gray )
                                )
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        //dys pressure
                        VStack(alignment:.leading,spacing:4){
                            TextField("Enter weight",text:self.$weight,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.weight = self.weight.filter { $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth:1)
                                        .stroke( Color.gray )
                                )
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        //comment
                        VStack(alignment:.leading,spacing:4){
                            
                            TextField("Any extra info",text:self.$extra)
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth:1)
                                        .stroke( Color.gray )
                                )
                                .foregroundColor(.black)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        Button(action:saveAction,label:{
                            Text("Update")
                                .fontWeight(.semibold)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding(12)
                        })
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .cornerRadius(8)
                        .padding(12)
                        .disabled(allDisabled)
                        
                    }//vstack
                }//scroll-view
                Spacer()
            }//vstack
            .disabled(allDisabled)
            
            
            if(alertMessage != nil){
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

                                Text(alertMessage ?? "none")
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
                            .cornerRadius(8)
                            Spacer()
                            
                        }//vstack
                    }//geometry
                    
                    Spacer()
                    
                }//vstack
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                .padding(36)
                .background(Color.black.opacity(0.1))
                
            }//if- alert
            
        }//zstack
        //.navigationBarHidden(false)
        .padding(12)
        .onAppear{
            fetchMyData()
        }
    }
}

struct MyProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        MyProfilePage()
    }
}
