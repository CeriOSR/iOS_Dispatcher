//
//  ViewController.swift
//  iOS_Dispatcher
//
//  Created by Rey Cerio on 2017-05-29.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    var dispatcher: Dispatcher? {
        didSet{
            navigationItem.title = dispatcher?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Message", style: .plain, target: self, action: #selector(handleMessageView))
        
        let layoutTracker = UICollectionViewFlowLayout()
        let trackerController = TrackerController(collectionViewLayout: layoutTracker)
        let trackerNavController = UINavigationController(rootViewController: trackerController)
        trackerNavController.tabBarItem.image = UIImage(named: "groups")
        trackerNavController.tabBarItem.title = "Drivers"
        
        let addUserController = AddUserController()
        let addUserNavController = UINavigationController(rootViewController: addUserController)
        addUserNavController.tabBarItem.image = UIImage(named: "people")
        addUserNavController.tabBarItem.title = "Add Driver"
        
        viewControllers = [trackerNavController, addUserNavController]
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
            return
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
//    func checkIfUserExist() {
//        if Auth.auth().currentUser?.uid != nil {
//            guard let uid = Auth.auth().currentUser?.uid else {return}
//            let dispatcherRef = Database.database().reference().child("CER_dispatcher").child(uid)
//            dispatcherRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                let dictionary = snapshot.value as! [String: Any]
//                let dispatcher = Dispatcher()
//                dispatcher.email = dictionary["email"] as? String
//                dispatcher.name = dictionary["name"] as? String
//                dispatcher.phone = dictionary["name"] as? String
//                dispatcher.userId = uid
//                let tabBarController = TabBarController()
//                tabBarController.dispatcher = dispatcher
//                self.present(tabBarController, animated: true, completion: nil)
//            }, withCancel: nil)
//        } else {
//            handleLogout()
//        }
//    }
    
    func handleMessageView() {
        let layout = UICollectionViewFlowLayout()
        let messageViewController = MessageViewController(collectionViewLayout: layout)
        messageViewController.dispatcher = dispatcher
        let messageNavController = UINavigationController(rootViewController: messageViewController)
        self.present(messageNavController, animated: true, completion: nil)
    }
    
    
}

