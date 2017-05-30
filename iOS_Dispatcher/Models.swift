//
//  Models.swift
//  CeriosDrivr
//
//  Created by Rey Cerio on 2017-02-28.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class Driver: NSObject {
    var userId: String?
    var name: String?
    var email: String?
    var phone: String?
    var trackerPhone: String?
}

class Dispatcher: NSObject {
    var userId: String?
    var name: String?
    var email: String?
    var phone: String?
}

class DriverLocation: NSObject {
    var date: String?
    var latitude: String?
    var longitude: String?
    var uid: String?
}

class Message: NSObject {
    var date: String?
    var dispatcherId: String?
    var dispatcherName: String?
    var message: String?
}
