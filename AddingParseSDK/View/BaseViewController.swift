//
//  BaseViewController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 7/8/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import UIKit
import JHSpinner

class BaseViewController: UIViewController {
    var spinner:JHSpinnerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayErrorMessage(message:String){
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)

    }

    func displayRegularMessage(message:String){
        let alertView = UIAlertController(title: "Message!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

    func isValidEmail(testStr:String) -> Bool {

        //print("validate emilId: \(testStr)")

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        let result = emailTest.evaluate(with: testStr)

        return result
    }

    func showSpinner(){
        spinner = JHSpinnerView.showOnView(view)
        self.view.addSubview(spinner)
    }

    func hideSpinner(){
        if self.spinner != nil{
            self.spinner.dismiss()
        }
    }

    func convertDateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let myString = formatter.string(from: date)
        return myString

    }
}
