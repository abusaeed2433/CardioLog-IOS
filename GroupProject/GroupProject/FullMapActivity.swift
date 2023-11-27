//
//  FullMapActivity.swift
//  GroupProject
//
//  Created by kuet on 12/11/23.
//

import SwiftUI
import MapKit


struct FullMapActivity: View {
    
    @State public var points:[MapPoint] = []
    @State var region:MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude:22.9006, longitude: 89.5024),
        span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
    
        //vstack-map
        VStack{
            Map(coordinateRegion: $region, annotationItems:points){item in
                MapMarker(coordinate: item.coordinate, tint: .blue)
            }
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: 0, maxHeight: .infinity
            )
            
        }//vstack-map
        
    }
}

struct FullMapActivity_Previews: PreviewProvider {
    static var previews: some View {
        FullMapActivity()
    }
}
