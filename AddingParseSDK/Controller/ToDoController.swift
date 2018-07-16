//
//  ToDoController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 7/8/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import Foundation
import Parse

class ToDoController: NSObject {
    static let sharedInstance = ToDoController()
    private override init() {
        super.init()
    }

    func getToDosForDate(date:Date, completion: @escaping (_ result: Bool, _ message:String, _ todoArray:[ToDo])->()){
        var resultToDoArray:[ToDo] = []
        let cloudParams : [AnyHashable:Any] = ["date":date]
        PFCloud.callFunction(inBackground: getToDosForUser, withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            if error != nil {
                if let descrip = error?.localizedDescription{
                    completion(false, descrip, resultToDoArray)
                }
            }else{
                resultToDoArray = result as! [ToDo]
                completion(true, "Success", resultToDoArray)
            }
        })
    }

    func saveToDo(todoString:String, completion: @escaping (_ result: Bool, _ message:String, _ todoArray:[ToDo])->()){
        var resultToDoArray:[ToDo] = []
        let cloudParams : [AnyHashable:Any] = ["todoString":todoString]
        PFCloud.callFunction(inBackground: createToDosForUser, withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            if error != nil {
                if let descrip = error?.localizedDescription{
                    completion(false, descrip, resultToDoArray)
                }
            }else{
                resultToDoArray = result as! [ToDo]
                completion(true, "Success", resultToDoArray)
            }
        })
    }

    func markToDosAsCompletedFor(todo:ToDo, completion: @escaping (_ result: Bool, _ message:String, _ todoArray:[ToDo])->()){
        var resultToDoArray:[ToDo] = []
        let cloudParams : [AnyHashable:Any] = ["todoId":todo.objectId ?? ""]
        PFCloud.callFunction(inBackground: markToDoAsCompletedForUser, withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            if error != nil {
                if let descrip = error?.localizedDescription{
                    completion(false, descrip, resultToDoArray)
                }
            }else{
                resultToDoArray = result as! [ToDo]
                completion(true, "Success", resultToDoArray)
            }
        })
    }

    func setUsersAclsNow(){
        if PFUser.current() != nil{
            let cloudParams : [AnyHashable:String] = ["test":"test"]
            PFCloud.callFunction(inBackground: setUsersAcls, withParameters: cloudParams, block: {
                (result: Any?, error: Error?) -> Void in
                if error != nil {
                    //print(error.debugDescription)
                    if let descrip = error?.localizedDescription{
                        print(descrip)
                    }
                }else{
                    print(result as! String)
                }
            })
        }
    }
}
