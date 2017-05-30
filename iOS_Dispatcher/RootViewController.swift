//
//  RootViewController.swift
//  iOS_Dispatcher
//
//  Created by Rey Cerio on 2017-05-29.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class RootViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //handleLogout()
        checkIfUserExist()            //view not loaded in heirarchy in viewDidLoad. call this func here because it will be presenting another viewController
    }
    
    func checkIfUserExist() {
        if Auth.auth().currentUser?.uid != nil {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let dispatcherRef = Database.database().reference().child("CER_dispatchers").child(uid)
            dispatcherRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String: Any]
                let dispatcher = Dispatcher()
                dispatcher.email = dictionary["email"] as? String
                dispatcher.name = dictionary["name"] as? String
                dispatcher.phone = dictionary["name"] as? String
                dispatcher.userId = uid
                let tabBarController = TabBarController()
                tabBarController.dispatcher = dispatcher
                let navTabBarController = UINavigationController(rootViewController: tabBarController)
                self.present(navTabBarController, animated: true, completion: nil)
            }, withCancel: nil)
        } else {
            handleLogout()
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
            return
        }
        let loginController = LoginController()
//        loginController.rootViewController = self
        self.present(loginController, animated: true, completion: nil)
    }

}
