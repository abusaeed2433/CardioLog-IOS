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
    @State private var isStepDownloaded:Bool = false;
    @State private var isPointDownloaded:Bool = false;
    
    @State private var myStepCount:Int = 0;
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:37.785834 , longitude: -122.406417), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    let ref = Database.database().reference();
    
    @Environment(\.presentationMode) var presentationMode
    
    private func onEditRequest(){
        showEditPage = true;
    }
    
    private func onDeleteRequest(){
        allDisabled = true;
        
        let defaults = UserDefaults.standard;
        let uid = defaults.string(forKey: "my_user_id");
        
        ref.child("data").child(uid!).child(String(clickedItem.timestamp))
            .removeValue { error, _ in
                allDisabled = false;
                if let err = error {
                    isAlert = true;
                    alertMessage = "Data could not be deleted: \(err.localizedDescription)";
                    
                }
                else {
                    isAlert = false;
                    alertMessage = "Data deleted successfully";
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
        
        stepRef.child(uid!).child(today).child("steps")
            .getData(completion:  { error, snapshot in
                if(error == nil) {
                    myStepCount = snapshot.value as? Int ?? 0;
                }
                print(today);
                print(snapshot);
                print("my step \(myStepCount)");
                isStepDownloaded = true;
        });
        
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
                            name: "lulu-lulu",
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
                        .frame(width: 120, height: 120)
                    
                    VStack{
                        
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
                                        .background(clickedItem.sysPressure < 20 ? Color.black : Color.red)
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
                                Text("Systolic pressure")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(clickedItem.sysPressure < 20 ? Color.black : Color.red)
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
                                Text("Diastolic pressure")
                                    .font(.custom("AmericanTypewriter", fixedSize:14) )
                                    .foregroundColor(.black)
                                VStack{
                                    Divider()
                                        .frame(height:2)
                                        .background(clickedItem.dysPressure < 20 ? Color.black : Color.red)
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
                                        .background(clickedItem.heartRate < 20 ? Color.black : Color.red)
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
                        
                        //comment
                        HStack{
                            
                            // Walking
                            VStack{
                                VStack{
                                    Image("step").resizable()
                                }//vstack
                                .frame(width: 40, height: 40)
                                Text("Steps")
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
                                        .background(Color.black)
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
                    .padding(8)
                    
                    if(isPointDownloaded){
                        // vstack-map
                        VStack{
                            Map(coordinateRegion: $region, annotationItems: pointsOfInterest) { item in
                                MapMarker(coordinate: item.coordinate, tint: .red)
                            }
                            .frame(
                                minWidth:0, maxWidth: .infinity,
                                minHeight: 180, maxHeight: .infinity
                            )
                        
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
                
                NavigationLink(
                    destination: EditPage(model: clickedItem),
                    isActive: $showEditPage,
                    label: {
                        EmptyView()
                })
                
                HStack{
                    
                    Spacer()
                    
                    HStack{
                        Button(action: onEditRequest, label: {
                            Text("EDIT")
                                .padding([.horizontal],12)
                                .padding([.vertical],8)
                                .foregroundColor(.black)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth:1)
                        )
                        
                        Button(action: onDeleteRequest, label: {
                            Text("DELETE")
                                .padding([.horizontal],12)
                                .padding([.vertical],8)
                                .foregroundColor(.red)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth:1)
                                .foregroundColor(.red)
                        )
                    }
                    .padding([.horizontal],12)
                    .padding([.vertical],8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth:1)
                    )
                }
                .frame(minWidth:0,maxWidth: .infinity,minHeight: 30)
                .padding(.top,24)
                                
                Spacer()
            }//vstack
            .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
            .disabled(allDisabled)
            
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
        
        ShowDetails(clickedItem: model)
        
    }
}
