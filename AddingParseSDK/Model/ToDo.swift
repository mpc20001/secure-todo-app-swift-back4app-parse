//
//  ToDo.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 7/8/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import UIKit
import Parse

class ToDo: PFObject {

    @NSManaged var name: String
    @NSManaged var user: User
    @NSManaged var userObjectId: String
    @NSManaged var todoDescription: String
    @NSManaged var finished: Bool
    @NSManaged var finishedDate: Date
}
extension ToDo: PFSubclassing {
    static func parseClassName() -> String {
        return "ToDo"
    }
}

