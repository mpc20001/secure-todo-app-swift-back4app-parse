//
//  LoggedInViewController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 4/12/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import UIKit
import Parse

class LoggedInViewController: BaseViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet fileprivate var tableView: UITableView!
    public var tableviewArray:[ToDo] = []
    public var resultsArray:[ToDo] = []
    fileprivate let cellIdentifier = "ToDoCell"
    @IBOutlet fileprivate var todoField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        todoField.text = ""
        let date = Date()
        ToDoController.sharedInstance.setUsersAclsNow()
        loadToDos(date:date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutOfApp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }else{
                    self.displayErrorMessage(message: "error logging out")
                }
            }
        }
    }

    @IBAction func createToDo(_ sender: UIButton) {
        var todoText = ""
        if let todo = todoField.text{
            todoText = todo;
        }
        showSpinner()
        ToDoController.sharedInstance.saveToDo(todoString: todoText) { (success, message, todoArray) in
            self.hideSpinner()
            if success{
                self.tableviewArray.insert(contentsOf: todoArray, at: 0)
                self.tableView.reloadData()
            }else{
                self.displayErrorMessage(message: message)
            }
        }
    }

    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }

    func loadToDos(date:Date){
        ToDoController.sharedInstance.getToDosForDate(date: date) { (success, message, todoArray) in
            if success{
                self.resultsArray.removeAll()
                self.resultsArray.append(contentsOf: todoArray)
                self.tableviewArray.append(contentsOf: todoArray)
                self.tableView.reloadData()
            }else{
                self.displayErrorMessage(message: message)
            }
        }
    }

    @objc func markAsRead(sender: UIButton){
        let buttonTag = sender.tag
        let todo:ToDo = tableviewArray[buttonTag]
        self.showSpinner()
        ToDoController.sharedInstance.markToDosAsCompletedFor(todo: todo) { (success, message, todoArray) in
            self.hideSpinner()
            if success{
                if (todoArray.count > 0) {
                    let updatedTodo = todoArray[0];
                    for todo in self.tableviewArray {
                        if (updatedTodo.objectId == todo.objectId) {
                            todo.finished = true;
                            todo.finishedDate = updatedTodo.finishedDate;
                        }
                    }
                }
                self.tableView.reloadData()
            }else{
                self.displayErrorMessage(message: message)
            }
        }
    }
}

extension LoggedInViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoCell
            else {
                assertionFailure()
                return UITableViewCell()
        }
        cell.contentView.tag = indexPath.row
        guard tableviewArray.count > indexPath.row else {
            cell.tag = 1
            return cell
        }
        let todo: ToDo = tableviewArray[indexPath.row]
        cell.todoLabel.text = todo.todoDescription
        if (todo.finished) {
            cell.todoDateLabel.isHidden = false
            cell.markSongAsReadBtn.isHidden = true
            cell.todoDateLabel.text = convertDateToString(date:todo.finishedDate)
        } else {
            cell.todoDateLabel.isHidden = true
            cell.markSongAsReadBtn.isHidden = false
            cell.todoDateLabel.text = ""
        }
        if (indexPath.row == tableviewArray.count-1 && resultsArray.count > 0) {
            cell.tag = 77
        }else{
            cell.tag = 1
        }
        cell.markSongAsReadBtn.tag = indexPath.row
        cell.markSongAsReadBtn.addTarget(self, action: #selector(LoggedInViewController.markAsRead(sender:)), for: .touchUpInside)
        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard tableviewArray.count > indexPath.row else {
            return
        }
        let todo:ToDo = tableviewArray[indexPath.row]
        if (cell.tag == 77) {
            cell.tag = 1
            if let date = todo.createdAt{
                self.loadToDos(date: date)
            }
        }
    }
}

extension LoggedInViewController: UITableViewDelegate {

}

