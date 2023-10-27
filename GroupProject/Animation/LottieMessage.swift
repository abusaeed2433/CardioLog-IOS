//
//  LottieMessage.swift
//  GroupProject
//
//  Created by Abu Saeed on 15/10/23.
//


import Lottie
import SwiftUI
import UIKit

struct LottieMessage : UIViewRepresentable{
    typealias UIViewType = UIView;
    
    func makeUIView(context: UIViewRepresentableContext<LottieMessage>) -> UIView {
        let view = UIView(frame: .zero);
        
        let animationView = AnimationView();
        
        animationView.contentMode = .scaleAspectFit;
        animationView.animation = Animation.named("message_lottie");
        animationView.loopMode = .loop;
        animationView.play();
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view;
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // nothing
    }
}
