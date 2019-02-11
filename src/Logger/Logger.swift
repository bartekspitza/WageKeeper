//
//  ViewController.swift
//  adding shifts
//
//  Created by Bartek  on 2017-10-24.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit
import CoreData

var shiftToEdit = [0,0]
var shifts = [[ShiftModel]]()
var shouldFetchAllData = false
var usingLocalStorage = false
var shiftsNeedsReOrganizing = false

class Logger: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let instructionsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shiftsNeedsReOrganizing {
            Periods.reOrganize()
            shiftsNeedsReOrganizing = false
            print("reorganized shifts")
        }
        
        hideTableIfEmpty()
        myTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        layoutView()
    }
    
    
    
    
    func hideTableIfEmpty() {
        if !(shifts.isEmpty) {
            myTableView.backgroundView = UIView()
        }
    }
    
    func layoutView() {
        myTableView.reloadData()
        myTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myTableView.frame.width, height: 1))
        myTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if shifts.isEmpty {
            let view = UIView()
            let image = UIImage(named: "test instructor")
            let imageview = UIImageView()
            
            imageview.image = image
            imageview.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.75), height: Int(self.view.frame.width*0.75))
            imageview.center = CGPoint(x: myTableView.center.x, y: myTableView.center.y - imageview.frame.height/4)

            view.addSubview(imageview)
            myTableView.backgroundView = view

        } else {
            myTableView.backgroundView = UIView()
        }
    }
    
    func showInstructions() {
        if shifts.isEmpty {
            let view = UIView()
            let image = UIImage(named: "test instructor")
            let imageview = UIImageView()
            imageview.image = image
            imageview.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.75), height: Int(self.view.frame.width*0.75))
            imageview.center = CGPoint(x: myTableView.center.x, y: myTableView.center.y - imageview.frame.height/4)

            view.alpha = 0
            view.addSubview(imageview)
            myTableView.backgroundView = view
            
            UIViewPropertyAnimator(duration: 0.75, curve: .linear, animations: {
                view.alpha = 1
            }).startAnimation()

        } else {
            myTableView.backgroundView = UIView()
        }
    }

    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete")   { (_ rowAction: UITableViewRowAction, _ indexPath: IndexPath) in
            
            if usingLocalStorage {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let shiftToDelete = LocalStorage.organizedValues[indexPath.section][indexPath.row]
                context.delete(shiftToDelete)
                
                
                do {
                    try context.save()
                    
                } catch {
                    
                }
                LocalStorage.organizedValues[indexPath.section].remove(at: indexPath.row)
            } else {
                let shiftToDelete = shifts[indexPath.section][indexPath.row]
                
                CloudStorage.deleteShift(fromUser: user.ID, shift: shiftToDelete)
            }
            
            
            // Removes the shift from the in memory database
            shifts[indexPath.section].remove(at: indexPath.row)
            // Cleans the arrays of empty sub arrays
            var i = 0
            while i < shifts.count {
                if shifts[i].count == 0 {
                    shifts.remove(at: i)
                    if usingLocalStorage {
                        LocalStorage.organizedValues.remove(at: i)
                    }
                } else {
                    i += 1
                }
            }
            
            if self.myTableView.numberOfRows(inSection: indexPath.section) > 1 {
                self.myTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            } else {
                self.myTableView.deleteSections([indexPath.section], with: UITableView.RowAnimation.automatic)
            }
            self.showInstructions()
        }
        deleteAction.backgroundColor = UIColor.gray
        return [deleteAction]
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shiftToEdit[0] = indexPath.section
        shiftToEdit[1] = indexPath.row
        performSegue(withIdentifier: "gotoedit", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainCell
        let shiftForRow = shifts[indexPath.section][indexPath.row]
        cell.noteLbl.text = shiftForRow.title
        cell.dateLbl.text = Time.dateToCellString(date: shiftForRow.date)
        cell.accessoryLbl.text = String(shiftForRow.breakTime) + "m break"
        cell.timeLbl.text = Time.dateToTimeString(date: shiftForRow.startingTime) + " - " + Time.dateToTimeString(date: shiftForRow.endingTime)
        cell.lunchLbl.text = shiftForRow.durationToString()
        
        cell.timeLbl.sizeToFit()
        cell.accessoryLbl.sizeToFit()
        cell.noteLbl.center.x = cell.timeLbl.frame.width + cell.noteLbl.frame.width/2 + 15
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 31
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var startDate = Time.dateToString(date: shifts[section][shifts[section].count-1].date, withDayName: false)
        startDate = String(startDate.prefix(startDate.count - 5))
        var endDate = Time.dateToString(date: shifts[section][0].date, withDayName: false)
        endDate = String(endDate.prefix(endDate.count - 5))
        let text = startDate + " - " + endDate
        
        let seperatorColor = myTableView.separatorColor
        let topSeperator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5))
        let bottomSeperator = UIView(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 0.5))
        topSeperator.backgroundColor = seperatorColor
        bottomSeperator.backgroundColor = seperatorColor
        
        let headerView = UIView()
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 15, width:
            tableView.bounds.size.width, height: 30))
        headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        headerLabel.textColor = .white
        headerLabel.text = text
        headerLabel.sizeToFit()
        headerLabel.center.x = self.view.frame.width/2
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = Colors.loggerSectionBG
        
        headerView.addSubview(topSeperator)
        headerView.addSubview(headerLabel)
        headerView.addSubview(bottomSeperator)
        
        
        return headerLabel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shifts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts[section].count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
