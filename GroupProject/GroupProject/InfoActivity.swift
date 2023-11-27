//
//  InfoActivity.swift
//  GroupProject
//
//  Created by Abu Saeed on 3/11/23.
//

import SwiftUI


extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct EachDiseaseLayout:View{
    let model:EachDisease;
    
    var body: some View{
        ZStack{
            VStack{
                Text(model.name)
                    .font(.custom("AmericanTypewriter", fixedSize:20))
                    .foregroundColor(.black)
                
                HStack{}
                    .frame(minWidth:0,maxWidth: .infinity,minHeight:2,maxHeight:2)
                    .overlay(
                        RoundedRectangle(cornerRadius:4).fill(Color.gray)
                    )
                    .padding([.vertical],4)
                    .padding(.trailing,8)
                
                HStack{
                    
                    VStack{
                        MyRemoteImage(
                            url: URL(string:model.imageUrl)!,
                            width: 60,
                            height: 60
                        )
                    }
                    
                    Spacer()
                    
                    Text(model.short_description)
                        .font(.custom("AmericanTypewriter", fixedSize:12))
                        .foregroundColor(.black)
                        .padding([.horizontal],2)
                    
                    
                }//vstack
                .padding(.leading,12)
                .padding(.top,4)
                
            }//hstack
            .cornerRadius(12)
            .padding(.leading,8)
            .padding([.vertical],8)
        }//zstack
        .frame(minWidth:0,maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .stroke(Color.purple)
        )
        .cornerRadius(8)
        .padding(0)
    }
}

public class NestedData:Codable,Identifiable,Hashable{
    
    let data: [String]
    let name:String
    
    init(data: [String], name: String) {
        self.data = data
        self.name = name
    }
    
    public static func == (lhs: NestedData, rhs: NestedData) -> Bool {
        return lhs.name == rhs.name && lhs.data == rhs.data
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(data)
    }
}

public class EachDisease:Codable, Identifiable{
    let name:String
    let nested:[NestedData]
    let imageUrl: String
    let short_description:String
    
    init(name: String, nested: [NestedData], imageUrl: String, short_description: String) {
            self.name = name
            self.nested = nested
            self.imageUrl = imageUrl
            self.short_description = short_description
    }
    
}

struct InfoActivity: View {
    
    
    @State var isDataLoaded:Bool = false;
    @State var allInfo: [EachDisease] = []
    @State var clickedItem:EachDisease? = nil;

    func fetchData(){
        
        print("isDataLoaded \(isDataLoaded)")
        if(isDataLoaded){ return; }
        
        print("fetching started2")
        let request = NSMutableURLRequest(
            url: NSURL(string:
                "https://api.myjson.online/v1/records/25f3a1a9-1962-4a95-b069-f3de1af36498"
                        /*"https://api.myjson.online/v1/records/b79678cb-9300-4d30-80f9-3c61a5bf9dcf"*/
            )! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data,r,err) -> Void in
                        
            if(err != nil){
                print("error \(err as Any)")
                return;
            }
            
            do {
                let decodedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                let temp = decodedData!["data"]! as? [String : Any]
                let result = temp!["heart_diseases"]
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: result!)
                    
                    print(json)
                    let decoder = JSONDecoder()
                    let diseases = try decoder.decode([EachDisease].self, from: json)
                    
                    allInfo = diseases
                    isDataLoaded = true;
                    print("isDataLoaded2 \(isDataLoaded)")
                }
                catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            catch {
                print("Error decoding JSON: \(error)")
            }
            
        })
        
        dataTask.resume();
    }
    
    func fetchDataPrev(){
        
        if(isDataLoaded) { return; }
        
        print("fetching started")
        let request = NSMutableURLRequest(
            url: NSURL(string: "https://api.myjson.online/v1/records/25f3a1a9-1962-4a95-b069-f3de1af36498"
            )! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data,response,err) -> Void in
            
            if(isDataLoaded) { return; }
            
            if(err != nil){
                
                print("error \(err as Any)")
                return;
            }
            do {
            
                let decodedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                
                let temp = decodedData!["data"]! as? [String : Any]
                
                let result = temp!["heart_diseases"]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result!)
                    let decoder = JSONDecoder()
                    let diseases = try decoder.decode([EachDisease].self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        allInfo = diseases;
                        
                        allInfo.forEach { (item) in
                            print(item.name)
                        }
                        
                        isDataLoaded = true;
                        print("Diseases: \(allInfo)")
                    }

                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            catch {
                print("Error decoding JSON: \(error)")
            }
            
        })
        
        dataTask.resume();
    }
    
    func dummyFetch(){
        
        let nestedDataExample = [
            NestedData(data: ["Data 1", "Data 2"], name: "Nested Data Name 1"),
            NestedData(data: ["Data 3", "Data 4"], name: "Nested Data Name 2")
        ]


        // Creating an EachDisease object
        let item = EachDisease(
            name: "Disease Name",
            nested: nestedDataExample,
            imageUrl: "https://example.com/image.jpg",
            short_description: "This is a short description of the disease."
        )
        
        allInfo.append(item)
        
        allInfo.append(item)

    }
    
    
    var body: some View {
        ZStack{
            VStack{
                
                if( !isDataLoaded ){
                    VStack{
                        LottieView(fileName:"lottie_loading")
                            .frame(width:180,height:90,alignment: .center)
                    }
                }
                
                NavigationView{
                    List{
                        ForEach(allInfo){item in
                            Button(action: { clickedItem = item }, label: {
                                EachDiseaseLayout(model: item)
                            })
                        }
                    }//list
                    .padding(0)
                    .padding(.top,8)
                }//navigation-view
            }
            .frame(minWidth:0, maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
            .onAppear{
                //dummyFetch()
                fetchData();
            }
            
            if(clickedItem != nil){
                
                VStack{
                    
                    FullInfoActivity(clickedItem: clickedItem!)
                    
                    Button(action: { clickedItem = nil }, label: {
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
            
        }//zstack
        .frame(minWidth:0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
        
    }
}

struct InfoActivity_Previews: PreviewProvider {
    static var previews: some View {
        InfoActivity()
    }
}
