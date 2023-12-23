//
//  AddPage.swift
//  GroupProject
//
//  Created by Abu Saeed on 9/10/23.
//

import SwiftUI
import FirebaseDatabase
import Foundation

struct AddPage: View {
    @State private var date:String="";
    @State private var time:String = "";
    @State private var sysPressure = "";
    
    @State private var dysPressure = "";
    @State private var heartRate = "";
    @State private var comment:String = "";
    
    @State private var allDisabled = false;
    @State private var showDatePicker:Bool = false;
    @State private var showTimePicker:Bool = false;
    
    @State private var alertMessage:String? = nil;
    @State private var isAlert = false;
    
    // date picker
    @State private var pickerDate: Date = Date();
    @State private var pickerTime = Date()
    
    //@State private var focusedIndex:Int = -1;
    
    @Binding var downloadRequested: Int64
    
    private func startDatePicker(){
        allDisabled = true;
        showDatePicker = true;
    }
    
    private func startTimePicker(){
        allDisabled = true;
        showTimePicker = true;
    }
    
    private func onDatePicked(_ dismissRequest:Bool=false){
        
        if(dismissRequest){
            allDisabled = false
            showDatePicker = false
            return
        }
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy";
        date = dateFormatter.string(from: pickerDate);
        
        allDisabled = false;
        showDatePicker = false;
    }
    
    private func onTimePicked(_ dismissRequest:Bool=false){
        
        if(dismissRequest){
            allDisabled = false
            showTimePicker = false
            return
        }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        time =  formatter.string(from: pickerTime)
        
        allDisabled = false;
        showTimePicker = false;
    }
    
    private func onErrorDismissed(){
        alertMessage = nil;
        allDisabled = false;
        isAlert = false;
    }
    
    func saveAction(){
        
        if( date.isEmpty || time.isEmpty || sysPressure.isEmpty ||
                dysPressure.isEmpty || heartRate.isEmpty ){
            
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
        do{
            allDisabled = true;
            
            let ref = Database.database().reference()
            let defaults = UserDefaults.standard;
            let uid = defaults.string(forKey: "my_user_id");
            
            let currentDate = Date()
            let timestamp = Int64(currentDate.timeIntervalSince1970)
            
            
            let sys:Int = Int(sysPressure) ?? 0;
            let dys:Int = Int(dysPressure) ?? 0;
            let hr:Int = Int(heartRate) ?? 0;
            
            let map:Any = [
                "timestamp": timestamp, "date": date,
                "time": time, "sysPressure": sys,
                "dysPressure": dys, "heartRate": hr,
                "comment": comment
            ]
            
            try ref.child("data").child(uid!).child(String(timestamp)).setValue(map) {(error,reference) in
                allDisabled = false;
                if let err = error {
                    alertMessage = "Data could not be saved. Because:  \(err.localizedDescription)";
                    isAlert = true;
                    
                }
                else {
                    date = "";
                    time = "";
                    sysPressure = "";
                    dysPressure = "";
                    heartRate = "";
                    comment = "";
                    alertMessage = "Data saved successfully";
                    downloadRequested = Int64(Date().timeIntervalSince1970)
                    isAlert = false;
                }
            }
            
            print("Save action clicked");
        }
        catch let err{
            allDisabled = true;
            isAlert = true;
            alertMessage = "Error: \(err)";
        }
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
                                .font(.system(size: 12))
                                .font(.callout)
                                .padding([.horizontal],8)
                            
                            Button(action:startDatePicker,label:{
                                TextField("01/05/2023",text:self.$date)
                                    .frame(height:40)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal],12)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(lineWidth:1)
                                            .stroke( Color.gray )
                                    )
                                    .foregroundColor(.black)
                                    .disabled(true)
                                    .multilineTextAlignment(.leading)
                            })
                        }//vstack
                        .padding(8)
                        
                        //time
                        VStack(alignment:.leading,spacing:4){
                            Text("Time(hh:mma)")
                                .font(.system(size: 12))
                                .font(.callout)
                                .padding([.horizontal],8)
                            
                            Button(action:startTimePicker,label:{
                                TextField("11:14PM",text:self.$time)
                                    .frame(height:40)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal],12)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(lineWidth:1)
                                            .stroke( Color.gray )
                                    )
                                    .foregroundColor(.black)
                                    .disabled(true)
                                    .multilineTextAlignment(TextAlignment.leading)
                            })//button
                            
                        }//vstack
                        .padding(8)
                        
                        //sys pressure
                        VStack(alignment:.leading,spacing:4){
                            Text("Sys pressure(mmHg)")
                                .font(.system(size: 12))
                                .font(.callout)
                                .padding([.horizontal],8)
                            TextField("140",text:self.$sysPressure,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.sysPressure = self.sysPressure.filter {    $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:40)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
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
                            Text("Dys pressure(mm Hg)")
                                .font(.system(size: 12))
                                .font(.callout)
                                .padding([.horizontal],8)
                            TextField("59",text:self.$dysPressure,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.dysPressure = self.dysPressure.filter { $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:40)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(lineWidth:1)
                                        .stroke( Color.gray )
                                )
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        // heart rate
                        VStack(alignment:.leading,spacing:4){
                            Text("Heart Rate(BPM)")
                                .font(.system(size: 12))
                                .font(.callout)
                                .padding([.horizontal],8)
                            TextField("105BPM",text:self.$heartRate,
                                      onEditingChanged: { isEditing in
                                        if !isEditing {
                                            self.heartRate = self.heartRate.filter { $0.isNumber }
                                        }
                                    }
                                )
                                .frame(height:40)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(lineWidth:1)
                                        .stroke( Color.gray )
                                )
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        //comment
                        VStack(alignment:.leading,spacing:4){
                            Text("Comment(If any)")
                                .font(.system(size: 12))
                                .font(.callout)
                                .padding([.horizontal],4)
                            TextField("Any extra message",text:self.$comment)
                                .frame(height:40)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal],12)
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(lineWidth:1)
                                        .stroke( Color.gray )
                                )
                                .foregroundColor(.black)
                                .disabled(allDisabled)
                        }//vstack
                        .padding(8)
                        
                        Button(action:saveAction,label:{
                            Text("Save Record")
                                .fontWeight(.semibold)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding(10)
                        })
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(32)
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
                        Button(action: {onDatePicked(true)}, label: {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .padding(8)
                        })
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                        .padding([.horizontal],8)
                        
                        Button(action: {onDatePicked(false)}, label: {
                            Text("OK")
                                .fontWeight(.semibold)
                                .padding(8)
                        })
                        .foregroundColor(.blue)
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
                        
                        Button(action: {onTimePicked(true)}, label: {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .padding(12)
                        })
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                        .padding([.horizontal],8)
                        
                        Button(action: {onTimePicked(false)}, label: {
                            Text("OK")
                                .fontWeight(.semibold)
                                .padding(12)
                        })
                        .foregroundColor(.blue)
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
            
        }//zstack
        //.navigationBarHidden(false)
        .padding(12)
    }
}

struct AddPage_Previews: PreviewProvider {
    static var previews: some View {
        AddPage(downloadRequested: .constant(123))
    }
}
