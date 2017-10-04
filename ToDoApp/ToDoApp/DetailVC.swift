//
//  DetailVC.swift
//  ToDoApp
//
//  Created by Waqar Zahour on 10/4/17.
//  Copyright © 2017 Waqar Zahour. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: IBOoutlet and Other Properties
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    let priorities = ["Low", "Medium", "High"]
    var todo: Todo?
    
    // MARK: View Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if todo != nil {
            nameField.text = todo!.name
            pickerView.selectRow(priorities.index(of: todo!.priority)!, inComponent: 0, animated: true)
        } else {
            deleteButton.isHidden = true
        }
    }
    
    // MARK: PickerView - Delegate and Datasource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when seelcted
    }

    
    // MARK: Button Actions
    /// In this function move back to the main screen
    ///
    /// - Parameters
    ///     sender: pass button reference
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /// In this function we'll delete the current todo item
    ///
    /// - Parameters
    ///     sender: pass button reference
    @IBAction func deleteButtonPressed(_ sender: Any) {
        DataLayer.instance.delete(todo: todo!)
        dismiss(animated: true, completion: nil)
    }
    
    /// In this function we'll save or update the todo item
    ///
    /// - Parameters
    ///     sender: pass button reference
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if (nameField.text?.characters.count)! <= 0 {
            let alertController = UIAlertController(title: ERROR_MESSAGE, message: NAME_ERROR, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: OKAY, style: .default, handler:nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        if todo != nil {
            let dict = [NAME:nameField.text!, PRIORITY: priorities[pickerView.selectedRow(inComponent: 0)]]
            DataLayer.instance.update(todo: todo!, dataDict: dict)
        } else {
            let todo = Todo()
            todo.name = nameField.text!
            todo.priority = priorities[pickerView.selectedRow(inComponent: 0)]
            todo.dateCreated = Date()
            DataLayer.instance.create(todo: todo)
        }
        dismiss(animated: true, completion: nil)
    }
}
