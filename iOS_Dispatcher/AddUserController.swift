//
//  AddUserController.swift
//  CeriosDrivr
//
//  Created by Rey Cerio on 2017-03-15.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit
import Firebase

class AddUserController: UIViewController {
    
//    var dispatcher = Dispatcher()
    let driver = Driver()
    let uid = Auth.auth().currentUser?.uid
    var dispatcher: Dispatcher? {
        didSet{
            navigationItem.title = dispatcher?.name
        }
    }

    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .phonePad
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "phone #"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 6.0
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let trackerIdTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "tracker ID"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 6.0
        tf.layer.masksToBounds = true
        tf.isUserInteractionEnabled = false
        tf.textColor = .gray
        return tf
    }()


    lazy var addUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add User", for: .normal)
        button.addTarget(self, action: #selector(handleAddUser), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        trackerIdTextField.text = uid
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        setupViews()

    }
    
    func setupViews() {
        view.addSubview(phoneTextField)
        view.addSubview(trackerIdTextField)
        view.addSubview(addUserButton)
        
        view.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: phoneTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: trackerIdTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-130-[v0(100)]", views: addUserButton)

        view.addConstraintsWithVisualFormat(format: "V:|-100-[v0(40)]-10-[v1(40)]-50-[v2(40)]", views: phoneTextField, trackerIdTextField, addUserButton)


    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleAddUser() {
        checkIfEmailTextFieldIsEmpty()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let phone = phoneTextField.text else {return}
        let pendingRef = Database.database().reference().child("CER_Pending_Drivers")
        pendingRef.observe(.childAdded, with: { (snapshot) in
            if phone == snapshot.value as? String {
                self.driver.phone = snapshot.value as? String
                self.driver.userId = snapshot.key
                guard let driverId = self.driver.userId else {return}
                let userRef = Database.database().reference().child("CER_drivers").child(driverId)
                userRef.updateChildValues(["trackerId": uid], withCompletionBlock: { (error, reference) in
                    if error != nil {
                        print(error ?? "unknown error!")
                        return
                    }
                    self.removeFromPendingAndAddToDispatcherUID(uid: uid)
                })
            }
        }, withCancel: nil)
    }
    func checkIfEmailTextFieldIsEmpty() {
        if phoneTextField.text == "" || phoneTextField.text == nil {
            createAlert(title: "Invalid Entry.", message: "Please enter a valid email address.")
        }
    }
    
    func removeFromPendingAndAddToDispatcherUID(uid: String) {
        
        if let driverId = driver.userId {
            print(driver.userId, driver.phone)
            guard let phoneNumber = driver.phone else {return}
            let companyDriversFanRef = Database.database().reference().child("CER_company_drivers").child("\(uid)")
            companyDriversFanRef.updateChildValues([driverId: phoneNumber])
            let pendingFanRef = Database.database().reference().child("CER_Pending_Drivers").child(driverId)
            pendingFanRef.removeValue()
            self.phoneTextField.text = nil
            self.createAlert(title: "Driver Added", message: "Check him in your list of drivers.")
        }
    }
    
    func handleBack() {
        let layout = UICollectionViewFlowLayout()
        let trackerController = TrackerController(collectionViewLayout: layout)
        let navController1 = UINavigationController(rootViewController: trackerController)
        self.present(navController1, animated: true, completion: nil)
    }

}
