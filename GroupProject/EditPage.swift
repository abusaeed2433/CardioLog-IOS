//
//  EditPage.swift
//  GroupProject
//
//  Created by Abu Saeed on 22/10/23.
//


import SwiftUI
import FirebaseDatabase
import Foundation

struct EditPage: View {
    
    @State var model:EachDataModel;
    
    @State private var date = "";
    @State private var time = "";
    @State private var sysPressure = "";
    @State private var dysPressure = "";
    @State private var heartRate = "";
    @State private var comment = "";
    
    @State private var allDisabled = false;
    @State private var showDatePicker:Bool = false;
    @State private var showTimePicker:Bool = false;
    
    @State private var alertMessage:String? = nil;
    @State private var isAlert = false;
    
    // date picker
    @State private var pickerDate: Date = Date();
    @State private var pickerTime = Date();
    let ref = Database.database().reference()
    
    @Environment(\.presentationMode) var presentationMode
    
    
    private func startDatePicker(){
        allDisabled = true;
        showDatePicker = true;
    }
    
    private func startTimePicker(){
        allDisabled = true;
        showTimePicker = true;
    }
    
    private func onDatePicked(){
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy";
        date = dateFormatter.string(from: pickerDate);
        
        allDisabled = false;
        showDatePicker = false;
    }
    
    private func onTimePicked(){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        time =  formatter.string(from: pickerTime)
        
        allDisabled = false;
        showTimePicker = false;
    }
    
    private func onErrorDismissed(){
        
        if( alertMessage == "Data updated successfully" ){
            presentationMode.wrappedValue.dismiss(); // back to showdetails
        }
        
        alertMessage = nil;
        allDisabled = false;
        isAlert = false;
    }
    
    func saveAction(){
        
        if( model.isAnyEmpty() ){
            alertMessage = "Fill all the form to continue";
            allDisabled = true;
            isAlert = true;
            return;
        }
        
        print("Entered info");
        print(date);
        print(time);
        print(sysPressure);
        print(dysPressure);
        print(heartRate);
        print(comment);
        
        allDisabled = true;
            
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        let sys:Int = Int(sysPressure) ?? 0;
        let dys:Int = Int(dysPressure) ?? 0;
        let hr:Int = Int(heartRate) ?? 0;
            
        let map:Any = [
            "timestamp": model.timestamp,
            "date": date,
            "time": time,
            "sysPressure": sys,
            "dysPressure": dys,
            "heartRate": hr,
            "comment": comment
        ]
        
        // todo add this after update successfull
        model.date = date; model.time = time;
        model.sysPressure = sys;
        model.dysPressure = dys;
        model.heartRate = hr;
        model.comment = comment;
        
        print("Hello map");
        print(map);
        ref.child("data").child(uid!).child(String(model.timestamp)).setValue(map) {(error,reference) in
                allDisabled = false;
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
                        //date
                        VStack(alignment:.leading,spacing:4){
                            Text("Date(dd/MM/yyyy)")
                                .frame(minHeight:18)
                                .font(.callout)
                                .padding([.horizontal],4)
                            
                            Button(action:startDatePicker,label:{
                                
                                TextField("01/05/2023",text:self.$date)
                                    .frame(height:48)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal],12)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray)
                                    )
                                    .background(
                                        Color.init(
                                            red: 0, green: 50, blue: 0
                                        )
                                    )
                                    .foregroundColor(.black)
                                    .disabled(true)
                            })
                        }//vstack
                        .padding(8)
                        
                        //time
                        VStack(alignment:.leading,spacing:4){
                            Text("Time(hh:mma)")
                                .frame(minHeight:18)
                                .font(.callout)
                                .padding([.horizontal],4)
                            
                            Button(action:startTimePicker,label:{
                                TextField("11:14PM",text:self.$time)
                                    .frame(height:48)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal],12)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray)
                                    )
                                    .background(
                                        Color.init(
                                            red: 0, green: 50, blue: 0
                                        )
                                    )
                                    .foregroundColor(.black)
                                    .disabled(true)
                            })//button
                            
                        }//vstack
                        .padding(8)
                        
                        //sys pressure
                        VStack(alignment:.leading,spacing:4){
                            Text("Sys pressure(mmHg)")
                                .frame(minHeight:18)
                                .font(.callout)
                                .padding([.horizontal],4)
                            TextField("140",text:self.$sysPressure,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.sysPressure = self.sysPressure.filter {    $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray)
                                )
                                .background(
                                    Color.init(
                                        red: 0, green: 50, blue: 0
                                    )
                                )
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        //dys pressure
                        VStack(alignment:.leading,spacing:4){
                            Text("Dys pressure(mm Hg)")
                                .frame(minHeight:18)
                                .font(.callout)
                                .padding([.horizontal],4)
                            TextField("59",text:self.$dysPressure,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.dysPressure = self.dysPressure.filter { $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray)
                                )
                                .background(
                                    Color.init(
                                        red: 0, green: 50, blue: 0
                                    )
                                )
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        // heart rate
                        VStack(alignment:.leading,spacing:4){
                            Text("Heart Rate(BPM)")
                                .frame(minHeight:18)
                                .font(.callout)
                                .padding([.horizontal],4)
                            TextField("105BPM",text:self.$heartRate,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.heartRate = self.heartRate.filter { $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray)
                                )
                                .background(
                                    Color.init(
                                        red: 0, green: 50, blue: 0
                                    )
                                )
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        //comment
                        VStack(alignment:.leading,spacing:4){
                            Text("Comment")
                                .frame(minHeight:18)
                                .font(.callout)
                                .padding([.horizontal],4)
                            TextField("Any extra message",text:self.$comment)
                                .frame(height:48)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray)
                                )
                                .background(
                                    Color.init(
                                        red: 0, green: 50, blue: 0
                                    )
                                )
                                .foregroundColor(.black)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        Button(action:saveAction,label:{
                            Text("Update")
                                .fontWeight(.semibold)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding(8)
                        })
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(12)
                        .disabled(allDisabled)
                        
                    }//vstack
                }//scroll-view
                Spacer()
            }//vstack
            .disabled(allDisabled)
            
            if(showDatePicker){
                VStack{
                    DatePicker("Date",
                           selection: $pickerDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    //Text("Selected Date: \(pickerDate, style: .date)")
                    
                    HStack{
                        Spacer()
                        Button(action: onDatePicked, label: {
                            Text("OK")
                                .fontWeight(.semibold)
                                .padding(12)
                        })
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                        .padding([.horizontal],8)
                    }//hstack
                }//vstack
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                )
            }//if - date picker
            
            if(showTimePicker){
                VStack{
                    DatePicker("Time", selection: $pickerTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    
                    HStack{
                        Spacer()
                        Button(action: onTimePicked, label: {
                            Text("OK")
                                .fontWeight(.semibold)
                                .padding(12)
                        })
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                        .padding([.horizontal],8)
                    }//hstack
                }//vstack
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                )
                
            }//if - time picker
            
            if(alertMessage != nil){
                VStack{
                    VStack{
                        Text(alertMessage ?? "none")
                            .frame(minHeight:18)
                            .font(.custom("AmericanTypewriter", fixedSize:18) )
                            .foregroundColor( isAlert ? Color.red : Color.black)
                            .padding(24)
                            .frame(minWidth:0,maxWidth: .infinity)

                        HStack{
                            Spacer()
                            Button(action: onErrorDismissed, label: {
                                Text("OK")
                                    .fontWeight(.semibold)
                                    .padding(12)
                            })
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            .padding([.horizontal],8)
                        }//hstack
                    }//vstack
                    .padding(4)
                    .cornerRadius(16)
                    .background(Color.white)
                }//vstack
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                .padding(36)
                .background(Color.black.opacity(0.4))
                
            }//if- alert
            
        }//zstack
        //.navigationBarHidden(false)
        .padding(12)
        .onAppear{
            
            print("Model timestamp \(model.timestamp)");
            
            date = model.date;
            time = model.time;
            sysPressure = model.getSysPressure();
            dysPressure = model.getDysPressure();
            heartRate = model.getHeartRate();
            comment = model.comment ?? "";
        }
    }
}

struct EditPage_Previews: PreviewProvider {
    static var previews: some View {
        
        let timestamp:Int64 = 123;
        let date:String = "21/03/2001"
        let time:String = "04:41PM";
        
        let sysPressure:Int = 120;
        let dysPressure:Int = 94;
        let heartRate:Int = 56;
        
        let comment:String = "No comment";
        
        //print(timestamp);
        let model:EachDataModel = EachDataModel(
            timestamp: timestamp,
            date: date, time: time,
            sysPressure: sysPressure, dysPressure: dysPressure, heartRate: heartRate,
            comment: comment);
        
        EditPage(model:model)
    }
}

