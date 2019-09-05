//
//  AddNewPersonViewController.swift
//  PairGenerator
//
//  Created by Madison Kaori Shino on 9/5/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class AddNewPersonViewController: UIViewController {
    
    //PROPERTIES
    var name: String?
    
    //OUTLETS
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
    }
    
    //ACTIONS
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if nameTextField.text != "" {
            name = nameTextField.text
            performSegue(withIdentifier: "toHomeVC", sender: self)
        }
    }
    
    func loadViews() {
        popupView.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
    }
}

//DISSMISS KEYBOARD
extension AddNewPersonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
