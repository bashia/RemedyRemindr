//
//  AddMedViewController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-08.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit
import CoreData

class AddMedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var medNameTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func testAction() {
        
        // Disable the text field and done button so the user can't keep typing
        //medNameTextField.enabled = false
        //doneButton.enabled = false
        
        let newMed = Medication(name: medNameTextField.text)
        MedicationDAO.insertData(newMed)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
