//
//  MyRemoteImage.swift
//  GroupProject
//
//  Created by Abu Saeed on 3/11/23.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

struct MyRemoteImage: View {
    @StateObject private var loader: ImageLoader
    @State private var width:CGFloat
    @State private var height:CGFloat
    
    init(
        url: URL,
        width: CGFloat,
        height: CGFloat
    )
    {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
        _width = State(initialValue: width );
        _height = State(initialValue: height );
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        ZStack {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .frame(width:width,height: height)
                
            }
            else {
                VStack{
                    Image("systolic").resizable()
                }
                .frame(width: 60, height: 60)
            }
        }
        .padding(4)
    }
}
