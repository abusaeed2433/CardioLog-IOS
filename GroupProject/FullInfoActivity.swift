//
//  FullInfoActivity.swift
//  GroupProject
//
//  Created by Abu Saeed on 4/11/23.
//

import SwiftUI

struct FullInfoActivity: View {
    
    @State public var clickedItem:EachDisease;
    
    var body: some View {
        
        ZStack{
            
            ScrollView{
                
                VStack{
                    
                    
                    VStack{
                        
                        MyRemoteImage(
                            url: URL(string:clickedItem.imageUrl)!,
                            width: CGFloat.infinity,
                            height: 220
                        )
                        
                        Text(clickedItem.name)
                            .font(
                                .system(size: 24,weight: .regular,design:.serif)
                            )
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                    
                    // short description
                    VStack{
                        HStack{}
                            .frame(minWidth:0,maxWidth: .infinity,minHeight:2,maxHeight:2)
                            .overlay(
                                RoundedRectangle(cornerRadius:4).fill(Color.gray)
                            )
                            .padding(4)
                        
                        Text(clickedItem.short_description)
                            .font(
                                .system(size: 16,weight: .regular,design:.serif)
                            )
                            .foregroundColor(.black)
                            .padding([.horizontal],2)
                    }//vstack
                    
                    ForEach(clickedItem.nested, id:\.self){sec in
                        
                        VStack{
                            HStack{}
                                .frame(minWidth:0,maxWidth: .infinity,minHeight:1,maxHeight:2)
                                .overlay(
                                    RoundedRectangle(cornerRadius:4).fill(Color.purple)
                                )
                                .padding(4)
                            
                            HStack{
                                Text(sec.name)
                                    .font(
                                        .system(size: 24,weight: .regular,design:.serif)
                                    )
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            ForEach(sec.data, id: \.self) {symptom in
                                
                                HStack{
                                    Text("-")
                                        .font(.custom("AmericanTypewriter", fixedSize:16))
                                        .fontWeight(.bold)
                                    
                                    Text(symptom)
                                        .font(.custom("AmericanTypewriter", fixedSize:16))
                                    Spacer()
                                
                                }
                                .padding([.vertical],1)
                                .padding([.horizontal],12)
                                
                            }//for-each loop
                        }//vstack
                    }
                     
                }//vstack
                
            }//scroll-view
            .padding(8)
            
        }//zstack
        
    }
    
}

struct FullInfoActivity_Previews: PreviewProvider {
    static var previews: some View {
        
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
        
        FullInfoActivity(clickedItem: item)
    }
}
