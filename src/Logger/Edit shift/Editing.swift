//
//  Editing.swift
//  SalaryCalc
//
//  Created by Bartek  on 2017-10-31.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit
import CoreData

class Editing: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveBtn.backgroundColor = navColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    @IBAction func save(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shift")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            // TODO: handle the error
        }
        
        shifts[shiftToEdit[0]][shiftToEdit[1]].date = currentTempShift.date
        shifts[shiftToEdit[0]][shiftToEdit[1]].startingTime = currentTempShift.startingTime
        shifts[shiftToEdit[0]][shiftToEdit[1]].endingTime = currentTempShift.endingTime
        shifts[shiftToEdit[0]][shiftToEdit[1]].lunchTime = currentTempShift.lunchTime
        shifts[shiftToEdit[0]][shiftToEdit[1]].note = currentTempShift.note
        shifts[shiftToEdit[0]][shiftToEdit[1]].newMonth = currentTempShift.newPeriod
        
        for section in shifts {
            for shift in section {
                context.insert(shift)
            }
        }
        
        do {
            try context.save()
            
        } catch {
            print(error)
        }
        performSegue(withIdentifier: "goback", sender: self)
    }
}
