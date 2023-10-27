//
//  FilterPage.swift
//  GroupProject
//
//  Created by Abu Saeed on 26/10/23.
//

import SwiftUI

struct FilterPage: View {

    @Environment(\.presentationMode) var presentationMode
    
    @State private var fromDate:String = "--/--/----";
    @State private var toDate:String = "--/--/----";
    
    @State private var showDatePicker:Bool = false;
    // date picker
    @State private var pickerDate:Date = Date();
    
    @State private var isFromDateRequested:Bool = true;
    @State private var allDisabled:Bool = false;
    
    @State private var sortStatus:Status = Status.NONE;
    @State private var sysStatus:Status = Status.NONE;
    @State private var dysStatus:Status = Status.NONE;
    @State private var heartStatus:Status = Status.NONE;
    
    @Binding var filterValue: Bool
    
    private func onDatePicked() -> Void {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy";
        let date = dateFormatter.string(from: pickerDate);
        
        if(isFromDateRequested){
            fromDate = date;
        }
        else{
            toDate = date;
        }
        
        allDisabled = false;
        showDatePicker = false;
    }
    
    private func sortBy(_ id:Status) -> Void {
        print("Filter by \(id)");
        sortStatus = id;
    }
    
    private func filterSys(_ id:Status) -> Void{
        print("sys filter \(id)")
        sysStatus = id;
    }
    
    private func filterDys(_ id:Status) -> Void{
        print("dys filter \(id)")
        dysStatus = id;
    }
    
    private func filterHeart(_ id:Status) -> Void{
        print("heart filter \(id)")
        heartStatus = id;
    }
    
    private func pickDate(_ id:Int) -> Void {
        
        isFromDateRequested = (id == 1);
        showDatePicker = true;
    }
    
    private func applyFilter(_ apply:Bool){
        
        if(apply){
            
            let defaults = UserDefaults.standard;
            
            defaults.set(fromDate, forKey: "from_date");
            defaults.set(toDate, forKey: "to_date");
            
            defaults.set(sortStatus.rawValue, forKey: "sort_status");
            defaults.set(sysStatus.rawValue, forKey: "sys_status");
            defaults.set(dysStatus.rawValue, forKey: "dys_status");
            defaults.set(heartStatus.rawValue, forKey: "heart_status");
            
            filterValue = !filterValue;
            
            presentationMode.wrappedValue.dismiss(); // back to homepage
            
        }
        else{
            fromDate = "--/--/----";
            toDate = "--/--/----";
            sortStatus = Status.NONE;
            sysStatus = Status.NONE;
            dysStatus = Status.NONE;
            heartStatus = Status.NONE;
        }
        // save in user-default
    }
    
    private func getStatus(id:Int ) -> Status{
        if(id == 1) { return Status.LOW; }
        if(id == 2) { return Status.NORMAL; }
        if(id == 3) { return Status.HIGH; }
        return Status.NONE;
    }
    
    private func readCurrentFilter() -> Void {
        
        let defaults = UserDefaults.standard;
        
        fromDate = defaults.string(forKey: "from_date") ?? "--/--/----";
        toDate = defaults.string(forKey: "to_date") ?? "--/--/----";
        
        sortStatus = getStatus(id: defaults.integer(forKey: "sort_status") );
        sysStatus = getStatus(id: defaults.integer(forKey: "sys_status") );
        dysStatus = getStatus(id: defaults.integer(forKey: "dys_status") );
        heartStatus = getStatus(id: defaults.integer(forKey: "heart_status") );
        
    }
    
    var body: some View {
        
        ZStack{
            VStack{
                
                // from, to picker
                HStack{
                    
                    Spacer(minLength: 40)
                    
                    HStack{
                        Button(action: { pickDate(1) }, label: {
                            HStack{
                                
                                VStack{
                                    Image("date_time").resizable()
                                }//vstack
                                .frame(width: 32, height: 32)
                                
                                VStack{
                                    
                                    Text("From date")
                                        .foregroundColor(.black)
                                        .font(.custom("AmericanTypewriter",fixedSize:10) )
                                    
                                    Text(fromDate)
                                        .foregroundColor(.blue)
                                        .font(.custom("AmericanTypewriter",fixedSize:12) )
                                        .bold()
                                    
                                }//vstack
                                
                            }//hstack
                        }) // button
                        
                        Spacer(minLength:60)
                        
                        Button(action: { pickDate(2) }, label: {
                            HStack{
                                
                                VStack{
                                    Image("date_time").resizable()
                                }//vstack
                                .frame(width: 32, height: 32)
                                
                                VStack{
                                    
                                    Text("To date")
                                        .foregroundColor(.black)
                                        .font(.custom("AmericanTypewriter",fixedSize:10) )
                                    
                                    Text(toDate)
                                        .foregroundColor(.blue)
                                        .font(.custom("AmericanTypewriter",fixedSize:11) )
                                        .bold()
                                    
                                }//vstack
                                
                            }//hstack
                        }) // button
                        
                    }
                    .padding([.vertical],8)
                    .padding([.horizontal],12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .stroke(Color.gray)
                    )
                    
                    Spacer(minLength: 40)
                    
                }//hstack
                .padding(.top,12)
                
                //sort by
                VStack{
                    
                    HStack{
                        Text("Sort By")
                            .foregroundColor(.black)
                            .font(.custom("AmericanTypewriter",fixedSize:18) )
                        Spacer()
                    }
                    .padding([.horizontal],12)
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {sortBy(Status.LOW)}, label: {
                            Text("Date")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (sortStatus == Status.LOW) ? 2:1
                                        )
                                        .stroke(
                                            (sortStatus == Status.LOW) ?
                                                Color.red : Color.gray
                                        )
                                )
                            
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: {sortBy(Status.NORMAL)}, label: {
                            Text("Sys")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (sortStatus == Status.NORMAL) ? 2:1
                                        )
                                        .stroke(
                                            (sortStatus == Status.NORMAL) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: {sortBy(Status.HIGH)}, label: {
                            Text("Dys")
                                .frame(minWidth:0,maxWidth: .infinity)
                                .foregroundColor(Color.black)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (sortStatus == Status.HIGH) ? 2:1
                                        )
                                        .stroke(
                                            (sortStatus == Status.HIGH) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        Spacer()
                    
                    }//hstack
                    
                }//vstack
                .padding([.horizontal],12)
                .padding([.vertical],12)
                
                // systolic pressure type
                VStack{
                    
                    HStack{
                        Text("Systolic pressure")
                            .foregroundColor(.black)
                            .font(.custom("AmericanTypewriter",fixedSize:18) )
                        Spacer()
                    }
                    .padding([.horizontal],12)
                    
                    HStack{
                        Spacer()
                        
                        Button(action: { filterSys(Status.LOW) }, label: {
                            Text("Low")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        lineWidth:
                                            (sysStatus == Status.LOW) ? 2:1
                                    )
                                    .stroke(
                                        (sysStatus == Status.LOW) ?
                                            Color.red : Color.gray
                                    )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: { filterSys(Status.NORMAL) }, label: {
                            Text("Normal")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (sysStatus == Status.NORMAL) ? 2:1
                                        )
                                        .stroke(
                                            (sysStatus == Status.NORMAL) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: { filterSys(Status.HIGH) }, label: {
                            Text("High")
                                .frame(minWidth:0,maxWidth: .infinity)
                                .foregroundColor(Color.black)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (sysStatus == Status.HIGH) ? 2:1
                                        )
                                        .stroke(
                                            (sysStatus == Status.HIGH) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        Spacer()
                    
                    }//hstack
                    
                }//vstack
                .padding([.horizontal],12)
                .padding([.vertical],12)
                
                // diastolic pressure
                VStack{
                    
                    HStack{
                        Text("Diastolic pressure")
                            .foregroundColor(.black)
                            .font(.custom("AmericanTypewriter",fixedSize:18) )
                        Spacer()
                    }
                    .padding([.horizontal],12)
                    
                    HStack{
                        Spacer()
                        
                        Button(action: { filterDys(Status.LOW) }, label: {
                            Text("Low")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (dysStatus == Status.LOW) ? 2:1
                                        )
                                        .stroke(
                                            (dysStatus == Status.LOW) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: { filterDys(Status.NORMAL) }, label: {
                            Text("Normal")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (dysStatus == Status.NORMAL) ? 2:1
                                        )
                                        .stroke(
                                            (dysStatus == Status.NORMAL) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: { filterDys(Status.HIGH) }, label: {
                            Text("High")
                                .frame(minWidth:0,maxWidth: .infinity)
                                .foregroundColor(Color.black)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (dysStatus == Status.HIGH) ? 2:1
                                        )
                                        .stroke(
                                            (dysStatus == Status.HIGH) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        Spacer()
                    
                    }//hstack
                    
                }//vstack
                .padding([.horizontal],12)
                .padding([.vertical],12)
            
                // heart rate
                VStack{
                    
                    HStack{
                        Text("Heart Rate")
                            .foregroundColor(.black)
                            .font(.custom("AmericanTypewriter",fixedSize:18) )
                        Spacer()
                    }
                    .padding([.horizontal],12)
                    
                    HStack{
                        Spacer()
                        
                        Button(action: { filterHeart(Status.LOW) }, label: {
                            Text("Low")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (heartStatus == Status.LOW) ? 2:1
                                        )
                                        .stroke(
                                            (heartStatus == Status.LOW) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: { filterHeart(Status.NORMAL) }, label: {
                            Text("Normal")
                                .foregroundColor(Color.black)
                                .frame(minWidth:0,maxWidth: .infinity)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (heartStatus == Status.NORMAL) ? 2:1
                                        )
                                        .stroke(
                                            (heartStatus == Status.NORMAL) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        
                        Button(action: { filterHeart(Status.HIGH) }, label: {
                            Text("High")
                                .frame(minWidth:0,maxWidth: .infinity)
                                .foregroundColor(Color.black)
                                .padding([.horizontal],16)
                                .padding([.vertical],6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            lineWidth:
                                                (heartStatus == Status.HIGH) ? 2:1
                                        )
                                        .stroke(
                                            (heartStatus == Status.HIGH) ?
                                                Color.red : Color.gray
                                        )
                                )
                        })//button
                        .frame(minWidth:0,maxWidth: .infinity)
                        Spacer()
                    
                    }//hstack
                    
                }//vstack
                .padding([.horizontal],12)
                .padding([.vertical],12)
                
                Spacer()
                
                // clear, apply filter
                VStack{
                    
                    HStack{
                        Button(action: { applyFilter(false); } , label: {
                            Text("CLEAR FILTER")
                                .foregroundColor(.white)
                                .frame(height:40)
                                .frame(width: UIScreen.main.bounds.width * 0.6)
                                .background(Color.red)
                                .cornerRadius(8)
                            
                        })//button
                        Spacer()
                    }//hstack
                    
                    HStack{
                        Spacer()
                        Button(action: { applyFilter(true); }, label: {
                            Text("APPLY FILTER")
                                .foregroundColor(.white)
                                .frame(height:40)
                                .frame(width: UIScreen.main.bounds.width * 0.6)
                                .background(Color.blue)
                                .cornerRadius(8)
                            
                        })//button
                    }//hstack
                    .padding(.top,4)
                    
                    
                }//vstack
                .padding([.horizontal],12)
                
            }//vstack
            .onAppear{
                readCurrentFilter();
            }
        
            
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
            
        }//zstack
        
        
    }
}


struct FilterPage_Previews: PreviewProvider {
    static var previews: some View {
        FilterPage(filterValue: .constant(true))
    }
}
