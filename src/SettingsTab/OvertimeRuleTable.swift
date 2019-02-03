//
//  OvertimeRuleTable.swift
//  SalaryCalc
//
//  Created by Bartek  on 2017-11-06.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class myTextField:UITextField {
    var path = Int()
}
var day = ""

class OvertimeRuleTable: UITableViewController, UITextFieldDelegate {
    

    let timePicker = UIDatePicker()
    var sectionFlag = 0
    var startFocused = Bool()
    
    // Arrays
    var rateFields = [myTextField]()
    var ends = [[Any]]()
    var starts = [[Any]]()
    var leftBtnView = UIView()
    
    // Other variables
    @IBOutlet var myTableView: UITableView!
    var isSectionComplete = [false, false]
    var startHasNotRecievedST = [Bool]()
    
    // Toolbar
    let toolbar = UIToolbar()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        configureToolbar()
        if UserDefaults().value(forKey: day) != nil {
            let instanceEncoded: [NSData] = UserDefaults().object(forKey: day) as! [NSData]
            let startsUnpacked = NSKeyedUnarchiver.unarchiveObject(with: instanceEncoded[0] as Data)
            let endsUnpacked = NSKeyedUnarchiver.unarchiveObject(with: instanceEncoded[1] as Data)
            let rateFieldsUnpacked = NSKeyedUnarchiver.unarchiveObject(with: instanceEncoded[2] as Data)
            
            starts = startsUnpacked as! [[Any]]
            ends = endsUnpacked as! [[Any]]
            rateFields = rateFieldsUnpacked as! [myTextField]
            
            for section in starts {
                (section[0] as! myTextField).font = UIFont.systemFont(ofSize: 15)
                (section[0] as! myTextField).attributedPlaceholder = NSAttributedString(string:"Start", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
                (section[0] as! myTextField).borderStyle = .none
                (section[0] as! myTextField).textAlignment = .center
                (section[0] as! myTextField).inputAccessoryView = toolbar
                (section[0] as! myTextField).addTarget(self, action: #selector(STPressed), for: UIControl.Event.editingDidBegin)
                (section[0] as! myTextField).inputView = timePicker
                (section[0] as! myTextField).tintColor = UIColor.clear
                startHasNotRecievedST.append(false)
            }
            for section in ends {
                (section[0] as! myTextField).font = UIFont.systemFont(ofSize: 15)
                (section[0] as! myTextField).attributedPlaceholder = NSAttributedString(string:"End", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
                (section[0] as! myTextField).borderStyle = .none
                (section[0] as! myTextField).textAlignment = .center
                (section[0] as! myTextField).inputAccessoryView = toolbar
                (section[0] as! myTextField).addTarget(self, action: #selector(ETPressed), for: UIControl.Event.editingDidBegin)
                (section[0] as! myTextField).inputView = timePicker
                (section[0] as! myTextField).tintColor = UIColor.clear
            }
            for field in rateFields {
                field.inputAccessoryView = toolbar
                field.keyboardType = .numberPad
                field.clearsOnBeginEditing = true
                field.textAlignment = .right
                field.borderStyle = .none
                field.font = UIFont.systemFont(ofSize: 15)
                field.attributedPlaceholder = NSAttributedString(string:"for this interval", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            }
            isSectionComplete = [true, true]
        }
    
        let rightBtn = UIBarButtonItem(title: "Add rule", style: .plain, target: self, action: #selector(addRulePressed))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = day
        timePicker.addTarget(self, action: #selector(timePickerChanged), for: UIControl.Event.valueChanged)
        timePicker.datePickerMode = .time
        
        if starts.isEmpty {
            isSectionComplete = [true, true]
            addRulePressed()
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            var indxCount = 0
            while (indxCount != starts.count) {
                if !(rateFields[indxCount].text != "" && (starts[indxCount][0] as! myTextField).text != "" && (ends[indxCount][0] as! myTextField).text != "") {
                    rateFields.remove(at: indxCount)
                    starts.remove(at: indxCount)
                    ends.remove(at: indxCount)
                } else {
                    indxCount += 1
                }
            }
            
            if starts.count > 0 {
                let encodedStarts = NSKeyedArchiver.archivedData(withRootObject: starts)
                let encodedEnds = NSKeyedArchiver.archivedData(withRootObject: ends)
                let encodedRateFields = NSKeyedArchiver.archivedData(withRootObject: rateFields)

                let encodedArr: [NSData] = [encodedStarts as NSData, encodedEnds as NSData, encodedRateFields as NSData]
                UserDefaults().set(encodedArr, forKey: day)
                UserDefaults().synchronize()
            } else {
                UserDefaults().set(nil, forKey: day)
            }
        }
    }
    
    func configureToolbar() {
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace, doneButton], animated: false)
        doneButton.tintColor = navColor
    }
    
    @objc func addRulePressed() {
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white.withAlphaComponent(0.3)
        
        if !isSectionComplete.contains(false) {
            isSectionComplete = [false, false]
            startHasNotRecievedST.append(true)
            
            let endField = myTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: 20))
            endField.font = UIFont.systemFont(ofSize: 15)
            endField.attributedPlaceholder = NSAttributedString(string:"End", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            endField.borderStyle = .none
            endField.textAlignment = .center
            endField.inputAccessoryView = toolbar
            endField.addTarget(self, action: #selector(ETPressed), for: UIControl.Event.editingDidBegin)
            endField.inputView = timePicker
            endField.tintColor = UIColor.clear
            ends.append([endField, startDate()])

            
            
            let startField = myTextField(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width/7), height: 20))
            startField.font = UIFont.systemFont(ofSize: 15)
            startField.attributedPlaceholder = NSAttributedString(string:"Start", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            startField.borderStyle = .none
            startField.textAlignment = .center
            startField.inputAccessoryView = toolbar
            startField.addTarget(self, action: #selector(STPressed), for: UIControl.Event.editingDidBegin)
            startField.inputView = timePicker
            startField.tintColor = UIColor.clear
            if starts.isEmpty {
                starts.append([startField, startDate()])
            } else {
                starts.append([startField, ends[ends.count-2][1] as! Date])
            }

            
            let rateField = myTextField(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width/2), height: 20))
            rateField.inputAccessoryView = toolbar
            rateField.keyboardType = .numberPad
            rateField.clearsOnBeginEditing = true
            rateField.textAlignment = .right
            rateField.borderStyle = .none
            rateField.font = UIFont.systemFont(ofSize: 15)
            rateField.attributedPlaceholder = NSAttributedString(string:"for this interval", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            rateFields.append(rateField)
            
            let indexSet = NSMutableIndexSet()
            indexSet.add(starts.count-1)
            myTableView.insertSections(indexSet as IndexSet, with: UITableView.RowAnimation.fade)
        }
    }
    
    func startDate() -> Date {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let newDate = cal.startOfDay(for: date)
        return newDate
    }
    
    @objc func timePickerChanged(sender: UIDatePicker) {
        if startFocused {
//            if sectionFlag > 0 {
//                if (sender.date > (ends[sectionFlag-1][1] as! Date)) {
//
//                    starts[sectionFlag][1] = sender.date
//                    (starts[sectionFlag][0] as! myTextField).text = createTime(Date: starts[sectionFlag][1] as! Date)
//                } else {
//                    sender.date = starts[sectionFlag][1] as! Date
//                }
//            }
            
            starts[sectionFlag][1] = sender.date
            (starts[sectionFlag][0] as! myTextField).text = createTime(Date: starts[sectionFlag][1] as! Date)
            
            
            
            // Handling endField date
            if (ends[sectionFlag][0] as! myTextField).text == "" {
                ends[sectionFlag][1] = createNextTime(Date: sender.date)
            } else if !(sender.date < (ends[sectionFlag][1] as! Date)) {
                ends[sectionFlag][1] = createNextTime(Date: sender.date)
                (ends[sectionFlag][0] as! myTextField).text = createTime(Date: ends[sectionFlag][1] as! Date)
            }
            
        } else {
            if (sender.date > (starts[sectionFlag][1] as! Date)) {
                ends[sectionFlag][1] = sender.date
                (ends[sectionFlag][0] as! myTextField).text = createTime(Date: sender.date)
            } else {
                sender.date = ends[sectionFlag][1] as! Date
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == starts.count-1{
            let versionText = UILabel()
            versionText.text = "  For accurate salary calculations, make sure intervals are not overlapping each other."
            versionText.numberOfLines = 3
            versionText.textColor = UIColor.black.withAlphaComponent(0.25)
            versionText.font = UIFont.systemFont(ofSize: 13)
            versionText.textAlignment = .center
            
            return versionText
        } else {
            return UIView()
        }
    }
    

    
    @objc func ETPressed(_ sender: myTextField) {
        sectionFlag = sender.path
        if ends.count-1 == sectionFlag {
            isSectionComplete[1] = true
        }
        startFocused = false
        timePicker.date = ends[sectionFlag][1] as! Date
        
        if sender.text == "" {
            sender.text = createTime(Date: ends[sectionFlag][1] as! Date)
        }
        
        if !isSectionComplete.contains(false) {
            self.navigationItem.rightBarButtonItem?.tintColor = .white
        }
    }
    @objc func STPressed(_ sender: myTextField) {
        // Keeping track of which section we are in
        sectionFlag = sender.path
        
        // Sets the first element of iSsectionComplete to true if we are in the last section
        if starts.count-1 == sectionFlag {
            isSectionComplete[0] = true
        }
        startFocused = true
        timePicker.date = starts[sectionFlag][1] as! Date
        
        if sender.text == "" {
            sender.text = createTime(Date: starts[sectionFlag][1] as! Date)
            if (ends[sectionFlag][0] as! myTextField).text == "" {
                ends[sectionFlag][1] = createNextTime(Date: starts[sectionFlag][1] as! Date)
            } else {
                if timePicker.date > createBeforeTime(Date: (ends[sectionFlag][1] as! Date)) {
                    ends[sectionFlag][1] = createNextTime(Date: timePicker.date)
                    (ends[sectionFlag][0] as! myTextField).text = createTime(Date: ends[sectionFlag][1] as! Date)
                }
            }
        }
        
        if !(isSectionComplete.contains(false)) {
            self.navigationItem.rightBarButtonItem?.tintColor = .white
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        // Interval Cell
        if indexPath.row == 0 {
            (ends[indexPath.section][0] as! myTextField).frame = CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: cell.frame.height)
            (ends[indexPath.section][0] as! myTextField).center.x = (self.view.frame.width*0.98) - (ends[indexPath.section][0] as! myTextField).frame.width/2
            (ends[indexPath.section][0] as! myTextField).path = indexPath.section
            
            let label = UILabel()
            label.text = "-"
            label.sizeToFit()
            label.center.y = cell.frame.height/2
            label.center.x = (self.view.frame.width*0.98) - (ends[indexPath.section][0] as! myTextField).frame.width - label.frame.width/2
            
            (starts[indexPath.section][0] as! myTextField).frame = CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: cell.frame.height)
            (starts[indexPath.section][0] as! myTextField).center.x = (self.view.frame.width*0.98) - (ends[indexPath.section][0] as! myTextField).frame.width - label.frame.width - (starts[indexPath.section][0] as! myTextField).frame.width/2
            (starts[indexPath.section][0] as! myTextField).path = indexPath.section
            
            cell.addSubview(label)
            cell.addSubview((starts[indexPath.section][0] as! myTextField))
            cell.addSubview((ends[indexPath.section][0] as! myTextField))
            cell.textLabel?.text = "Interval"
            // Rate Cell
        } else {
            rateFields[indexPath.section].frame = CGRect(x: 0, y: 0, width: (self.view.frame.width/2), height: cell.frame.height)
            rateFields[indexPath.section].center.x = (self.view.frame.width*0.95) - rateFields[indexPath.section].frame.width/2
            rateFields[indexPath.section].path = indexPath.section
            
            cell.addSubview(rateFields[indexPath.section])
            cell.textLabel?.text = "Hourly wage"
        }
        return cell
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == starts.count-1 {
            return 40
        } else {
            return 0.1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RULE " + (section + 1).description
    }
    
    func createTime(Date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: Date)
        
        return dateString
    }
    func createNextTime(Date: Date) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 1, to: Date)!
        
        return date
    }
    
    func createBeforeTime(Date: Date) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -1, to: Date)!
        
        return date
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return starts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction()
        
        delete.title = "Delete"
        delete.backgroundColor = UIColor.gray
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete")   { (_ rowAction: UITableViewRowAction, _ indexPath: IndexPath) in
            
            if indexPath.section == self.starts.count-1 {
                self.isSectionComplete = [true, true]
                self.navigationItem.rightBarButtonItem?.tintColor = .white
                
            }
            
            if !(indexPath.section == self.starts.count-1) { // If element is not the last one in the arrays
                for section in self.starts[indexPath.section+1..<self.starts.count] {
                    (section[0] as! myTextField).path -= 1
                }
                for section in self.ends[indexPath.section..<self.ends.count] {
                    (section[0] as! myTextField).path -= 1
                }
            }
            
            self.rateFields.remove(at: indexPath.section)
            self.starts.remove(at: indexPath.section)
            self.ends.remove(at: indexPath.section)
            self.myTableView.deleteSections([indexPath.section], with: UITableView.RowAnimation.fade)
            self.myTableView.reloadData()
            
        }
        deleteAction.backgroundColor = UIColor.gray
        return [deleteAction]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            rateFields[indexPath.section].becomeFirstResponder()
        }
    }
}
