//
//  HomeActivity.swift
//  GroupProject
//
//  Created by Abu Saeed on 8/10/23.
//

import SwiftUI
import FirebaseDatabase
import CoreMotion
import CoreLocation

public class EachDataModel : Identifiable{
    let timestamp:Int64; // will be used as id
    var date:String; // dd/MM/yyyy
    var time:String; // hh:mma
    
    var epochDate:TimeInterval;
    var sysPressure:Int; //mm Hg
    var dysPressure:Int; // mm Hg
    var heartRate:Int; // BPM
    var comment:String?;
    var steps:Int;
    
    init(timestamp:Int64,date:String,time:String,sysPressure:Int,dysPressure:Int,heartRate:Int, comment:String?) {
        
        self.timestamp = timestamp;
        self.date = date;
        self.time = time;
        self.sysPressure = sysPressure;
        self.dysPressure = dysPressure;
        self.heartRate = heartRate;
        self.comment = comment;
        self.epochDate = EachDataModel.getEpochDate(date:date);
        self.steps = 1223; // hudai, random.
    }
    
    public func doesFulfil(from:TimeInterval, to:TimeInterval, sys:Int, dys:Int, heart:Int) -> Bool {
        
        if(epochDate < from) { return false; }
        if(epochDate > to) { return false; }
        
        if( sys != 0 && getSysStatus() != sys ) { return false; }
        
        if( dys != 0 && getDysStatus() != dys ) { return false; }
        
        if( heart != 0 && getHeartStatus() != heart ) { return false; }
    
        return true;
    
    }

    public func getSysStatus() -> Int {
        if( sysPressure < 60 ) { return 1; }
        if( sysPressure > 90 ) { return 3; }
        
        return 2;
    }
    
    public func getDysStatus() -> Int {
        if( dysPressure < 60 ) { return 1; }
        if( dysPressure > 90 ) { return 3; }
        
        return 2;
    }
    
    public func getHeartStatus() -> Int {
        if( heartRate < 60 ) { return 1; }
        if( heartRate > 90 ) { return 3; }
        
        return 2;
    }
    
    public func getSysColor() -> Color {
        if( sysPressure < 60 ) { return Color.blue }
        if( sysPressure > 90 ) { return Color.red; }
        
        return Color.green;
    }
    
    public func getDysColor() -> Color {
        if( dysPressure < 60 ) { return Color.blue; }
        if( dysPressure > 90 ) { return Color.red; }
        
        return Color.red;
    }
    
    public func getHeartColor() -> Color {
        if( heartRate < 60 ) { return Color.blue; }
        if( heartRate > 90 ) { return Color.red; }
        
        return Color.green;
    }
    
    public func isAnyEmpty() -> Bool{
        return date.isEmpty || time.isEmpty;
    }

    private static func getEpochDate(date:String) -> TimeInterval {
        let pattern = "dd/MM/yyyy";
        let formatter = DateFormatter();
        formatter.dateFormat = pattern;
        
        formatter.locale = Locale(identifier: "en_US_POSIX");
        
        if let localDate = formatter.date(from: date){
            return localDate.timeIntervalSince1970
        }
        return TimeInterval(Int64.min);
        
    }
    
    public func getFormattedEpoch() ->String{
        let curDate = Date()
        let date = Date(timeIntervalSince1970: epochDate);
        let calendar = Calendar.current;
        let components = calendar.dateComponents(
            [.day,.hour,.minute],
            from:date,
            to:curDate
            )
        
        if let days = components.day, days > 0{
            return "\(days)d ago"
        }
        else if let hours = components.hour, hours>0{
            return "\(hours)h ago"
        }
        else if let minutes = components.minute, minutes>0{
            return "\(minutes)m ago"
        }
        
        return "just now"
    }
    
    public func getSteps() ->String{
        return String(steps);
    }
    
    public func getEpochDate() -> String{
        return String(epochDate);
    }
    public func getSysPressure() -> String{
        return String(sysPressure);
    }
    public func getDysPressure() -> String{
        return String(dysPressure);
    }
    public func getHeartRate() -> String{
        return String(heartRate);
    }
}

struct EachDataLayout:View{
    let model:EachDataModel;
    
    var body: some View{
        ZStack{
            //Button(action:{itemClicked(item:model)}){
                HStack{
                    
                    HStack{
                        VStack{
                            
                                Text(model.date)
                                    .font(.custom("AmericanTypewriter", fixedSize:12))
                                    .foregroundColor(.white)
                                Text(model.getFormattedEpoch())
                                    .font(.custom("AmericanTypewriter", fixedSize:12))
                                    .foregroundColor(.white)
                        }//vstack
                        .fixedSize()
                        .padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .background(
                            Rectangle().fill(Color.secondary)
                                .shadow(radius: 2).cornerRadius(6)
                        )
                        
                        VStack{//systolic
                            Text(model.getSysPressure())
                                .font(.custom("AmericanTypewriter", fixedSize:12))
                                .foregroundColor(.white)
                            Text("mm Hg")
                                .font(.custom("AmericanTypewriter", fixedSize:12))
                                .foregroundColor(.white)
                        }//vstack-systolic
                        .fixedSize()
                        .padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .background(
                            Rectangle().fill( model.getSysColor() )
                                .shadow(radius: 2).cornerRadius(6)
                        )
                        
                        VStack{//diastolic
                            Text(model.getDysPressure())
                                .font(.custom("AmericalTypewriter", fixedSize:12))
                                .foregroundColor(.white)
                            Text("mm Hg")
                                .font(.custom("AmericalTypewriter", fixedSize:12))
                                .foregroundColor(.white)
                        }//vstack-diastolic
                        .fixedSize()
                        .padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .background(
                            Rectangle().fill(model.getDysColor())
                                .shadow(radius: 2).cornerRadius(6)
                        )
                        
                        VStack{//heart_rate
                            Text(model.getHeartRate())
                                .font(.custom("AmericalTypewriter", fixedSize:12))
                                .foregroundColor(.white)
                            Text("BPM")
                                .font(.custom("AmericalTypewriter", fixedSize:12))
                                .foregroundColor(.white)
                        }//vstack-heart-rate
                        .fixedSize()
                        .padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .background(
                            Rectangle().fill(model.getHeartColor())
                                .shadow(radius: 2).cornerRadius(6)
                        )
                    }//hstack
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(minWidth:0,maxWidth: .infinity)
                
                }//hstack
            //}//butotn
        }//zstack
        .cornerRadius(8)
        .padding(8)
    }
}

private var allData:[EachDataModel] = [];
private var allDataWithoutFilter:[EachDataModel] = [];

private var clickedItemId:Int64 = -1;
private var clickedItem:EachDataModel? = nil;
private var showItemDetails:Bool = false;
private var isAlreadyDownloaded:Bool = false;
private var showAddPage:Bool = false;


private func dotAction(model:EachDataModel){
    if(clickedItemId != -1){
        clickedItemId = -1;
        print("Hidden popup by dot")
        return
    }
    
    clickedItemId = model.timestamp;
    print("dot action clicked");
}

private func itemClicked(item:EachDataModel){
    if(clickedItemId != -1){
        clickedItemId = -1;
        return;
    }
    
    clickedItem = item;
    showItemDetails = true;
    print("Item clicked");
}

private func addClicked(){
    showAddPage = true;
    print("Add clicked");
}

struct HomeActivity: View {
    @State var timeNow = ""
    private let TOP_TIMER_HEIGHT:CGFloat = 28;
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    @State var isListEmpty:Bool = true;
    @State var hasLoggedOut:Bool = false;
    @State var showApiPage:Bool = false;
    @State var isDrawerOpen:Bool = false;
    @State var isShowInfoCalled:Bool = false;
    @State var isShowProfileCalled:Bool = false;
    
    private var dateFormatter:DateFormatter{
        let fmtr = DateFormatter();
        fmtr.dateFormat = "hh:mm:ssa";
        return fmtr;
    }
    
    @StateObject var locationManager = LocationManager();
    var latitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0;
    }
    var longitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0;
    }
    
    let stepRef = Database.database().reference().child("steps");
    let pathRef = Database.database().reference().child("paths");
    @State private var stepCount: Int = 0;
    private let pedometer = CMPedometer();
    private let
        pathIdForCurrentSession = String( Int64( Date().timeIntervalSince1970));

    @State private var filterValue:Bool = false;
    @State private var isAnyFilterApplied:Bool = false;
    @State private var downloadRequested:Int64 = 54;
    
    private func getFormattedDate() -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd-MM-yyyy";
        
        let date = dateFormatter.string(from: Date());
        return date;
    }
    
    private func startStepCounter(){
        print("started counter");
        
        guard CMPedometer.isStepCountingAvailable() else {
            // counting not available here
            print("No counter on emulator");
            return;
        }
        
        pedometer.startUpdates(from: Date() ){ data,error in
            if let stepData = data, error == nil{
                DispatchQueue.main.async {
                    self.stepCount = stepData.numberOfSteps.intValue;
                    saveStepCount(stepCount: stepCount);
                }
            }
        }
        
    }
    
    private func saveStepCount(stepCount:Int) -> Void{
        //if(stepCount % 5 != 0) { return; }
        let locationManager = CLLocationManager();
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        print(latitude); print(longitude);
        
        print("Stepcount \(stepCount)");

        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        let timestamp = Int64( Date().timeIntervalSince1970);
        let today = getFormattedDate();
    
        stepRef.child(uid!).child(today).child("steps")
            .getData(completion:  { error, snapshot in
                
                var prevValue:Int = 0;
                
                if(error != nil){
                    prevValue = snapshot.value as? Int ?? 0;
                }
                
                let curValue = prevValue + stepCount;
                
                let map:Any = [ "timestamp": timestamp, "steps":curValue ];
                stepRef.child(uid!).child(today).setValue(map);
            });
        
        let locMap = [ "lat": latitude, "long": longitude ];
        
        pathRef.child(uid!).child(today).child(pathIdForCurrentSession).childByAutoId().setValue(locMap)
    }
    
    private func downloadData(){
        
        print("downlaod data called");
        
        /*
        if(isAlreadyDownloaded) {
            //stepCount = stepCount + 1;
            //saveStepCount(stepCount: stepCount*5)
            return;
        }
        */
        
        isAlreadyDownloaded = false;
        startStepCounter();
        
        let ref = Database.database().reference()
        
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        ref.child("data").child(uid!).observeSingleEvent(of: .value){ snapshot in
        //ref.child("data").child(uid!).observe(DataEventType.value, with: { snapshot in
            
            allData.removeAll();
            allDataWithoutFilter.removeAll();
    
            for record in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let data = record.value as? [String: Any] {
                    
                    let timestamp:Int64 = data["timestamp"] as? Int64 ?? 0;
                    let date:String = data["date"] as! String;
                    let time:String = data["time"] as! String;
                    
                    let sysPressure:Int = data["sysPressure"] as! Int;
                    let dysPressure:Int = data["dysPressure"] as! Int;
                    let heartRate:Int = data["heartRate"] as! Int;
                    
                    let comment:String = data["comment"] as? String ?? "No comment";
                    
                    //print(timestamp);
                    let model:EachDataModel = EachDataModel(
                        timestamp: timestamp,
                        date: date, time: time,
                        sysPressure: sysPressure, dysPressure: dysPressure, heartRate: heartRate,
                        comment: comment);
                    
                    allData.append(model);
                    allDataWithoutFilter.append(model);
                }
            }
            isAlreadyDownloaded = true;
            applyFilter();
        }
    }
    
    private func filterAction(){
        print("Filter button clicked");
        
        stepCount = stepCount + 1;
        saveStepCount(stepCount: stepCount*5)
    }
    
    private func editAction(){
        print("edit clicked");
        clickedItemId = -1;
    }
    
    private func deleteAction(){
        print("delete action");
        clickedItemId = -1;
    }
    
    private func getEpochDate(date:String) -> TimeInterval {
        let pattern = "dd/MM/yyyy";
        let formatter = DateFormatter();
        formatter.dateFormat = pattern;
        
        formatter.locale = Locale(identifier: "en_US_POSIX");
        
        if let localDate = formatter.date(from: date){
            return localDate.timeIntervalSince1970
        }
        return TimeInterval(Int64.min);
        
    }
    
    private func applyFilter(){
        
        let defaults = UserDefaults.standard;
        
        let strFromDate:String = defaults.string(forKey: "from_date") ?? "--/--/----";
        let strToDate = defaults.string(forKey: "to_date") ?? "--/--/----";
        
        isAnyFilterApplied = (strFromDate != "--/--/----") || (strToDate != "--/--/----");
        
        let fromEpoch:TimeInterval =
            (strFromDate == "--/--/----") ? TimeInterval(Int64.min) :
                                   getEpochDate(date: strFromDate);
        
        let toEpoch:TimeInterval =
            (strToDate == "--/--/----") ? TimeInterval(Int64.max) :
                                 getEpochDate(date: strToDate);
        
        let sortStatus = defaults.integer(forKey: "sort_status");
        
        let sysStatus = defaults.integer(forKey: "sys_status");
        let dysStatus = defaults.integer(forKey: "dys_status");
        let heartStatus = defaults.integer(forKey: "heart_status");
        
        
        isAnyFilterApplied = (isAnyFilterApplied || (sortStatus != 0) ||
            (sysStatus != 0) || (dysStatus != 0) || (heartStatus != 0) );
        
        /*
        print(strFromDate);
        print(strToDate);
        
        print(fromEpoch);
        print(toEpoch);
        
        print(sysStatus)
        print(dysStatus)
        print(heartStatus)
        print(sortStatus)
        */
        
        var templist:[EachDataModel] = [];
        
        allDataWithoutFilter.forEach { (model) in
            
            if( model.doesFulfil(from: fromEpoch, to: toEpoch, sys: sysStatus,
                                 dys: dysStatus, heart: heartStatus) ){
                templist.append(model);
            }
            
        }
        
        let sortedData = templist.sorted(by: { (model1, model2) -> Bool in
            
            if(sortStatus == 2){ // sys
                return model1.sysPressure < model2.sysPressure;
            }
            else if(sortStatus == 3){ // dys
                return model1.dysPressure < model2.dysPressure;
            }
            
            return model1.epochDate < model2.epochDate;
        })
        
        allData = sortedData;
        
        isListEmpty = allData.count == 0;
        
    }
    
    var body: some View {
        VStack{
            
            ZStack{
                
                if(hasLoggedOut){
                    LoginPage()
                }
                else{
                    VStack{
                        NavigationView{
                            ZStack{
                                
                                VStack{
                                    HStack{
                                        Text(timeNow)
                                            .onReceive(timer){
                                                _ in self.timeNow = dateFormatter.string(from: Date())
                                            }
                                            .frame(height:TOP_TIMER_HEIGHT)
                                            .frame(minWidth:0,maxWidth: .infinity)
                                            .padding(4)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color.gray)
                                            )//text
                                        
                                        Button(action:filterAction,label:{
                                            
                                            NavigationLink(destination:FilterPage(filterValue: $filterValue)){
                                                Text("Filter")
                                                    .fontWeight(.semibold)
                                                    .padding()
                                            }//nav-link
                                            
                                        })
                                        .frame(height:TOP_TIMER_HEIGHT)
                                        .padding(4)
                                        .foregroundColor(Color.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    lineWidth: isAnyFilterApplied ? 2: 1
                                                )
                                                .stroke(
                                                    isAnyFilterApplied ? Color.red : Color.gray
                                                    )
                                        )//butotn
                                    }//hstack
                                    .padding(8)
                                    Spacer()
                                    List{
                                        ForEach(allData){item in
                                            
                                            EachDataLayout(model: item)
                                                .frame(minWidth:0,maxWidth:.infinity)
                                                .background(
                                                    
                                                    NavigationLink("",
                                                        destination:
                                                            ShowDetails(clickedItem: item,downloadRequested: $downloadRequested)
                                                    )
                                                    .opacity(0)
                                                    
                                                )//inside background
                                            
                                            
                                            //.buttonStyle(PlainButtonStyle())
                                            
                                        }
                                        .padding(0)
                                        .frame(minWidth:0,maxWidth: .infinity)
                                    }//list
                                }//vstack
                                
                                if -1 != clickedItemId{
                                    HStack(alignment:.center){
                                        Spacer()
                                        VStack{
                                            Button(action:editAction,label:{
                                                Text("Edit")
                                                    .padding(
                                                        EdgeInsets(
                                                            top:8,leading: 60,
                                                            bottom: 16,trailing: 60
                                                        )
                                                    )
                                            })//button
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                        }//vstack
                                        .background(Color.gray)
                                        .cornerRadius(8)
                                        Spacer()
                                    }//hstack
                                }//pop-if
                                
                                if(isAlreadyDownloaded && isListEmpty){
                                    
                                    Text("NO DATA FOUND")
                                        .font(.custom("AmericanTypewriter", fixedSize:24))
                                }
                                
                                if(!isAlreadyDownloaded ){
                                    VStack{
                                        LottieView(fileName:"lottie_loading")
                                            .frame(width:180,height:90,alignment: .center)
                                        Spacer()
                                    }
                                    .padding(.top,24)
                                    .padding(4)
                                    .cornerRadius(12)
                                }
                                
                                VStack{
                                    Spacer()
                                    
                                    HStack{
                                        Spacer()
                                        NavigationLink(
                                            destination: InfoActivity(),
                                            isActive: $isShowInfoCalled,
                                            label: {
                                                EmptyView()
                                        })
                                        
                                        NavigationLink(
                                            destination: MyProfilePage(),
                                            isActive: $isShowProfileCalled,
                                            label: {
                                                EmptyView()
                                        })
                                        
                                        //
                                        
//                                        NavigationLink( destination: InfoActivity()){
//                                            VStack{
//                                                Image(systemName: "heart.fill")
//                                                    .foregroundColor(.red)
//                                                    .frame(width:48,height:48)
//                                            }
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 8)
//                                                    .stroke(lineWidth:1)
//                                                    .stroke(Color.red)
//                                            )
//                                            .padding(.trailing, 12)
//                                        }
                                            
                                    }
                                    
                                    Button(action:addClicked,label:{
                                        NavigationLink(destination:AddPage(downloadRequested: $downloadRequested)){
                                            VStack{
                                                Image(systemName: "plus")
                                                    .resizable()
                                                    .foregroundColor(Color.black)
                                                    .frame(width:40,height:40)
                                                
                                            }
                                            .padding(6)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black,lineWidth:4)
                                            )
                                        }
                                    })

                                }//vstack add
                                .padding(4)
                                
                                
                            }//zstack
                            .navigationBarTitle("Overview", displayMode: .inline)
                            .toolbar{
                                
                                
                                ToolbarItem(placement:.navigationBarLeading){

                                    Button(action: {
                                        isDrawerOpen = true
                                    },
                                    label: {
                                        Image(systemName: "line.horizontal.3")
                                            .foregroundColor(.red)
                                    })

                                }
                                
//                                ToolbarItem(placement:.navigationBarTrailing){
//
//                                    Button(action: {
//                                        let defaults = UserDefaults.standard;
//                                        defaults.removeObject(forKey: "my_user_id")
//                                        defaults.set(false, forKey: "am_i_logged_in");
//                                            hasLoggedOut = true;
//                                    },
//                                    label: {
//                                        Image(systemName: "power")
//                                            .foregroundColor(.red)
//                                    })
//
//                                }
                            }
                        }//navigation-view
                        .listStyle(GroupedListStyle())
                        .padding(8)
                        .onAppear{
                            downloadData();
                        }
                        .onChange(of: downloadRequested, perform: {value in
                            downloadData()
                            print("download requested \(downloadRequested)")
                        })
                        .onChange(of: filterValue, perform: { value in
                            applyFilter();
                            print("filterValue \(filterValue)");
                            
                        })
                        
                    }//vstack
                    .disabled(isDrawerOpen)

                }//else
                
                
                MyNavDrawer(isOpen: isDrawerOpen){ data in
                    
                    isDrawerOpen = false;
                    if(data == "log_out"){
                        let defaults = UserDefaults.standard;
                        defaults.removeObject(forKey: "my_user_id")
                        defaults.set(false, forKey: "am_i_logged_in");
                        hasLoggedOut = true;
                    }
                    else if(data == "show_profile"){
                        let seconds = 0.500;
                        DispatchQueue.main.asyncAfter(deadline: .now()+seconds){
                            isShowProfileCalled.toggle();
                        }
                        
                    }
                    else if(data == "show_api" ){
                        
                        let seconds = 0.500;
                        DispatchQueue.main.asyncAfter(deadline: .now()+seconds){
                            isShowInfoCalled.toggle();
                        }
                       
                    }
                    
                }
                
            }//zstack
            .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
            
        }//vstack
        
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    
}


struct MyNavDrawer : View {
    private let width = UIScreen.main.bounds.width * 0.8
    private let height = UIScreen.main.bounds.height
    
    let isOpen: Bool
    var onActionRequested: (String) -> Void
    
    var body: some View{
        HStack{
            VStack{
                
                
                VStack{
                    
                    HStack{
                    }
                    .frame(height:60)
                    
                    Image("heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Button(action:{ onActionRequested("show_profile") },label:{
                        Text("Profile")
                            .fontWeight(.semibold)
                            .frame(minWidth:0,maxWidth: .infinity)
                            .padding(10)
                    })
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .stroke(Color.black)
                            
                    )
                    .cornerRadius(8)
                    .padding(4)
                    .padding([.horizontal],12)
                    
                    
                    Button(action:{ onActionRequested("show_api") },label:{
                        Text("Show info")
                            .fontWeight(.semibold)
                            .frame(minWidth:0,maxWidth: .infinity)
                            .padding(10)
                    })
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .stroke(Color.black)
                            
                    )
                    .cornerRadius(8)
                    .padding(4)
                    .padding([.horizontal],12)
                    
                    
                    Button(action:{ onActionRequested("log_out") },label:{
                        Text("LogOut")
                            .fontWeight(.semibold)
                            .frame(minWidth:0,maxWidth: .infinity)
                            .padding(10)
                    })
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .stroke(Color.red)
                            
                    )
                    .cornerRadius(8)
                    .padding(4)
                    .padding([.horizontal],12)
                    
                    Spacer()
                    
                    Button(action:{
                        onActionRequested("close")
                    }, label: {
                        Image("heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding(4)
                    })
                    
                    HStack{}.frame(height:10)
                    
                }//vstack
                .frame(width:self.width, height: self.height)
                .background( Color(white: 0.9) )
                .cornerRadius(8)
                .offset(x:self.isOpen ? 0 : -self.width)
                .animation(.default)
                
                Spacer()
            }//vstack
            .frame(width:self.width, height: self.height)
            Spacer()
        }//hstack
        .allowsTightening(false)
    }
    
}

struct HomeActivity_Previews: PreviewProvider {
    static var previews: some View {
        //HomeActivity()
        MyNavDrawer(isOpen:true){data in}
    }
}
