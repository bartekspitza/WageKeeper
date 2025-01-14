//
//  Time.swift
//  WageKeeper
//
//  Created by Maikzy on 2019-02-04.
//  Copyright © 2019 Bartek . All rights reserved.
//

import Foundation

class Time {
    static let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    static let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    static let formatter = DateFormatter()
    static let calendar = Calendar.current
    
    static func getWeekday(fromDate: Date) -> String {
        return Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: fromDate)-1]
    }
    
    static func weekday(afterDay: String) -> String {
        let i = weekDays.firstIndex(of: afterDay)
        return (i == 6) ? weekDays[0] : weekDays[i!+1]
    }
    
    static func calculateMinutes(from: Date, to: Date) -> Float {
        var minutesWorked = 0
        var hoursWorked = 0
        
        let startingHour = Int(String(Array(from.description)[11...12]))
        let startingMin = Int(String(Array(from.description)[14...15]))
        let endingHour = Int(String(Array(to.description)[11...12]))
        let endingMin = Int(String(Array(to.description)[14...15]))
        
        if endingHour! - startingHour! > 0 {
            hoursWorked = endingHour! - startingHour!
        } else if endingHour! - startingHour! < 0 {
            hoursWorked = 24 + (endingHour! - startingHour!)
        }
        
        if endingMin! - startingMin! < 0 {
            hoursWorked -= 1
            minutesWorked = 60 - (startingMin! - endingMin!)
        } else if endingMin! - startingMin! > 0 {
            minutesWorked = endingMin! - startingMin!
        }
        
        minutesWorked += (hoursWorked * 60)
        
        return Float(minutesWorked)
    }
    
    static func minutesToHoursAndMinutes(minutes: Int) -> [Int] {
        var minutesWorked = minutes
        
        let hoursWorked = minutes/60
        minutesWorked -= (minutes/60) * 60
        
        return [hoursWorked, minutesWorked]
    }
    
    static func dateToString(date: Date, withDayName: Bool) -> String {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let dateString = formatter.string(from: date)

        if withDayName {
            let dayName = getWeekday(fromDate: date)
            return dayName + ", " + dateString.replacingOccurrences(of: ",", with: "")
        }
        
        return dateString.replacingOccurrences(of: ",", with: "")
    }
    
    static func dateToTimeString(date: Date) -> String {
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    static func dateToCellString(date: Date) -> String {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        var dateString = formatter.string(from: date)
        dateString = String(Array(formatter.string(from: date))[0..<dateString.count-4])
        return dateString.replacingOccurrences(of: ",", with: "")
    }
    
    static func combineDateWithTime(date: Date, time: Date) -> Date? {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        
        return calendar.date(from: mergedComponments)
    }
    
    static func createDefaultST() -> Date {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        return Calendar.current.date(byAdding: .hour, value: 7, to: date)!
    }
    static func createDefaultET() -> Date {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        return Calendar.current.date(byAdding: .hour, value: 15, to: date)!
    }
    static func beginningOfDay() -> Date {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }
    static func stringToDate(date: String) -> Date {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: date)!
    }
}
