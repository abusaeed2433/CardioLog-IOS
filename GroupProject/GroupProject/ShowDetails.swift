//
//  ShowDetails.swift
//  GroupProject
//
//  Created by Abu Saeed on 8/10/23.
//

import SwiftUI
import FirebaseDatabase
import MapKit

struct MapPoint: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

private var pointsOfInterest:[MapPoint] = [];

struct ShowDetails: View {
    
    @State public var clickedItem:EachDataModel;
    @State private var alertMessage:String? = nil;
    @State private var isAlert = false;
    @State private var allDisabled = false;
    @State private var showEditPage = false;
    @State private var showFullMap = false;
    @State private var isStepDownloaded:Bool = false;
    @State private var isPointDownloaded:Bool = false;
    
    @State private var myStepCount:Int = 0;
    
    @State var region:MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude:22.9006, longitude: 89.5024),
        span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    let ref = Database.database().reference();
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var downloadRequested: Int64
    
    private func onEditRequest(){
        showEditPage = true;
    }
    
    private func onDeleteRequest(){
        allDisabled = true;
        
        
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        ref.child("data").child(uid!).child(String(clickedItem.timestamp))
            .removeValue { error, _ in
                print("Done")
                
                allDisabled = false;
                if let err = error {
                    isAlert = true;
                    alertMessage = "Data could not be deleted: \(err.localizedDescription)";
                    
                }
                else {
                    isAlert = false;
                    alertMessage = "Data deleted successfully";
                    downloadRequested = Int64(Date().timeIntervalSince1970)
                }
            }
    }
    
    private func onErrorDismissed(){
        allDisabled = false;
        isAlert = false;
        
        if(alertMessage == "Data deleted successfully"){
            presentationMode.wrappedValue.dismiss(); // back to homepage
        }
        
        alertMessage = nil;
        
    }
    
    private func getFormattedDate() -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd-MM-yyyy";
        
        let date = dateFormatter.string(from: Date());
        return date;
    }
    
    private func downloadSteps() -> Void {
        
        if(isStepDownloaded){ return; }
        
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        let today = clickedItem.date.replacingOccurrences(of: "/", with: "-");
        
        let stepRef = Database.database().reference().child("steps");
        
        //stepRef.child(uid!).child(today).child("steps").getData(completion:  { error, snapshot in
            
        stepRef.child(uid!).child(today).child("steps").observeSingleEvent(of: .value){ snapshot in
                
                myStepCount = snapshot.value as? Int ?? 0;
                print(today);
                print("my step \(myStepCount)");
                isStepDownloaded = true;
        };
        
    }
    
    private func downloadMapPoints() -> Void {
        
        if( isPointDownloaded ){ return; }
        
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        let today = (clickedItem.date).replacingOccurrences(of: "/", with: "-");
        // not today actually
        print(today);
        
        let pathRef = Database.database().reference().child("paths")
            .child(uid!).child(today);
        
        pathRef.observe(DataEventType.value, with: { snapshot in

            pointsOfInterest.removeAll();
            
            // session
            for session in snapshot.children.allObjects as! [DataSnapshot] {
                // point
                print("session \(session)");
                for record in session.children.allObjects as! [DataSnapshot]{
                    
                    if let data = record.value as? [String: Any] {
                        
                        let lat:Double = data["lat"] as? Double ?? -1;
                        let long:Double = data["long"] as? Double ?? -1;
                        
                        let point = MapPoint(
                            name: "----",
                            coordinate: .init( latitude: lat, longitude: long )
                        )
                        
                        pointsOfInterest.append( point );
                        
                    }
                    
                }
            }
            print("path points");
            print(pointsOfInterest.count);
            isPointDownloaded = true;
            
        });
    
    }
    
    var body: some View {
        
        ZStack{
        
            VStack{
                
                Spacer()
                
                ScrollView {
                    
                    VStack{}
                        .frame(width: 40, height: 40)
                    
                    VStack{
                        
                        //date-time
                        HStack{
                            //date-time
                            VStack{
                                VStack{
                                    Image("date_time").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Date and Time")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(Color.gray)
                                }//vstack
                                .padding(4)
                                Text(clickedItem.getFormattedEpoch())
                                    .font(.custom("AmericanTypewriter",fixedSize:12) )
                                    .foregroundColor(Color.black)
                                    .bold()
                            }//vstack date-time
                            .cornerRadius(8)
                            .frame(minWidth:120,minHeight: 120)
                            .background(Color.init(red: 200, green: 180, blue: 120))
                            
                            //Systolic pressure
                            VStack{
                                VStack{
                                    Image("systolic").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Systolic Pressure")
                                    //.font(.system(size: 14))
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(clickedItem.getSysColor())
                                }//vstack
                                .padding(4)
                                Text(clickedItem.getSysPressure())
                                    .font(.custom("AmericanTypewriter",fixedSize:12) )
                                    .foregroundColor(Color.black)
                                    .bold()
                            }//vstack sys-pressure
                            .cornerRadius(8)
                            .frame(minWidth:120,minHeight: 120)
                            .background(Color.init(red: 200, green: 180, blue: 120))
                            
                        }//hstack
                        .padding(4)
                        
                        
                        //diastolic & heart rate
                        HStack{
                            
                            // diastolic pressure
                            VStack{
                                VStack{
                                    Image("diastolic").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Diastolic Pressure")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(clickedItem.getDysColor())
                                }//vstack
                                .padding(4)
                                Text(clickedItem.getDysPressure())
                                    .font(.custom("AmericanTypewriter",fixedSize:12) )
                                    .foregroundColor(Color.black)
                                    .bold()
                            }//vstack dys
                            .cornerRadius(8)
                            .frame(minWidth:120,minHeight: 120)
                            .background(Color.init(red: 200, green: 180, blue: 120))
                            
                            // diastolic pressure
                            VStack{
                                VStack{
                                    Image("heart_rate").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Heart Rate")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(clickedItem.getHeartColor())
                                }//vstack
                                .padding(4)
                                Text(clickedItem.getHeartRate())
                                    .font(.custom("AmericanTypewriter",fixedSize:12) )
                                    .foregroundColor(Color.black)
                                    .bold()
                            }//vstack dys
                            .cornerRadius(8)
                            .frame(minWidth:120,minHeight: 120)
                            .background(Color.init(red: 200, green: 180, blue: 120))
                            
                        }//hstack
                        .padding(4)
                        
                        //steps and comment
                        HStack{
                            
                            // Steps
                            VStack{
                                VStack{
                                    Image("step").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Steps Count")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(myStepCount > 240 ? Color.black : Color.red)
                                }//vstack
                                .padding(4)
                                Text(String(myStepCount))
                                    .font(.custom("AmericanTypewriter",fixedSize:12) )
                                    .foregroundColor(Color.black)
                                    .bold()
                            }//vstack dys
                            .cornerRadius(8)
                            .frame(minWidth:120,minHeight: 120)
                            .background(Color.init(red: 200, green: 180, blue: 120))
                            
                            // comment
                            VStack{
                                VStack{
                                    Image("comment").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Comment")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(Color.gray)
                                }//vstack
                                .padding(4)
                                Text(clickedItem.comment ?? "No comment")
                                    .font(.custom("AmericanTypewriter",fixedSize:12) )
                                    .foregroundColor(Color.black)
                                    .bold()
                            }//vstack comment
                            .cornerRadius(8)
                            .frame(minWidth:120,minHeight: 120)
                            .background(Color.init(red: 200, green: 180, blue: 120))
                            
                            
                            
                        }//hstack -  comment
                        .padding(8)
                        
                    }//vstack
                    .padding(16)
                    
                    if(isPointDownloaded){
                        
                        // vstack-map
                        VStack{
                            ZStack{
                                Map(coordinateRegion: $region, annotationItems: pointsOfInterest) { item in
                                    MapMarker(coordinate: item.coordinate, tint: .red)
                                }
                                .frame(
                                    minWidth:0, maxWidth: .infinity,
                                    minHeight: 180, maxHeight: .infinity
                                )
                                
                                VStack{
                                    HStack{
                                        Spacer()
                                        Button(action: {showFullMap = true;}, label: {
                                            Image(systemName: "rectangle")
                                                .padding(4)
                                        })
                                    }
                                    Spacer()
                                }
                            }
                        
                        }//vstack-map
                        .cornerRadius(8)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .padding(8)
                        )
                    }
                }//scroll-view
                
            }//vstack
            //.navigationBarTitle("Back", displayMode: .inline)
            //.navigationBarHidden(false)
            .disabled(allDisabled)
            
            VStack{
                
                
                
                
                HStack{
                    
                    Spacer()
                    
                    HStack{
                        Button(action: onEditRequest, label: {
                            Text("Edit")
                                .font(.system(size: 12))
                                .padding([.horizontal],12)
                                .padding([.vertical],4)
                                .foregroundColor(.black)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth:1)
                        )
                        
                        Button(action: onDeleteRequest, label: {
                            Text("Delete")
                                .font(.system(size: 12))
                                .padding([.horizontal],12)
                                .padding([.vertical],4)
                                .foregroundColor(.red)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth:1)
                                .foregroundColor(.red)
                        )
                    }//hstack
                    .padding(6)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth:1)
                    )
                    VStack{}.frame(width:2)
                    
                }//hstack
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 30)
                .padding(.top,24)
                                
                Spacer()
            }//vstack
            .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
            .disabled(allDisabled)
            
            if(showEditPage){
                VStack{
                    
                    EditPage(model: clickedItem)
                    
                    Button(action: { showEditPage = false }, label: {
                        Text("Close")
                            .foregroundColor(.blue)
                            .frame(height:32)
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .stroke(Color.black)
                            )
                            .cornerRadius(8)
                            .padding(.bottom,8)
                    })
                    
                }
                .background(Color.white)
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                
            }
            
            
            if(showFullMap){
                VStack{
                    
                    FullMapActivity(points: pointsOfInterest)
                    
                    Button(action: { showFullMap = false }, label: {
                        Text("Close")
                            .foregroundColor(.blue)
                            .frame(height:32)
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .stroke(Color.black)
                            )
                            .cornerRadius(8)
                            .padding(.bottom,8)
                    })
                    
                }
                .background(Color.white)
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                
            }
            
            
            
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
        
        }//z-stack
        .onAppear{
            downloadSteps()
            downloadMapPoints()
        }
        
    }//body
}//struct


struct ShowDetails_Previews: PreviewProvider {
    static var previews: some View {
        let model:EachDataModel = EachDataModel(
            timestamp: Int64(NSDate().timeIntervalSince1970),
            date: "17/09/2023",
            time: "12:16PM",
            sysPressure: 68, dysPressure: 110, heartRate: 96,
            comment: "no comment"
        )
        
        ShowDetails(clickedItem: model,downloadRequested: .constant(123))
        
    }
}
