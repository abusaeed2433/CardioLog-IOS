//
//  GroupProjectApp.swift
//  GroupProject
//
//  Created by Abu Saeed on 8/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }
}

@main
struct GroupProjectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var shouldOpenLogin:Bool = false;
    @State private var amILoggedIn:Bool = false;
    
    var body: some Scene {
        WindowGroup {
            //NavigationView{
                //VStack{
                    if(shouldOpenLogin){
                        if(amILoggedIn){
                            HomeActivity()
                        }
                        else{
                            LoginPage()
                        }
                    }
                    else{
                        SplashScreen()
                            .onAppear{
                                let seconds = 2.0;
                                DispatchQueue.main.asyncAfter(deadline: .now()+seconds){
                                    
                                    let defaults = UserDefaults.standard;
                                    amILoggedIn = defaults.bool(forKey: "am_i_logged_in");
                                    shouldOpenLogin = true;
                                }
                        }
                        
                    }
                //}//VStack
            //}//Navigation view
        }
    }
}
