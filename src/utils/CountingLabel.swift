//
//  CountingLabel.swift
//  SalaryCalc
//
//  Created by Bartek  on 2017-11-09.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    
    let counterVelocity: Float = 3.0
    
    enum CounterAnimationType {
        case Linear
        case EaseIn
        case EaseOut
    }
    enum CounterType {
        case Int
        case Float
    }

    var startNumber: Float = 0.0
    var endNumber: Float = 0.0
    
    var progress: TimeInterval!
    var duration:TimeInterval!
    var lastUpdate: TimeInterval!
    var preString: String!
    var afterString: String!
    
    var timer:Timer?
    
    var counterType: CounterType!
    var counterAnimationType: CounterAnimationType!
    
    var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
    }
    
    func count(fromValue: Float, to toValue: Float, withDuration duration: TimeInterval, andAnimationtype animationType: CounterAnimationType, andCounterType counterType: CounterType, preString: String, afterString: String) {
        
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterType = counterType
        self.counterAnimationType = animationType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        self.preString = preString
        self.afterString = afterString
        
        invalidateTimer()
        
        if duration == 0 {
            updateText(value: toValue)
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CountingLabel.updateValue), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        
        updateText(value: currentCounterValue)
    }
    
    func updateText(value:Float) {
        switch counterType! {
        case .Int:
            self.text = preString + Int(value).currencyString() + afterString
        case .Float:
            self.text = preString + String(format: "%2f", value) + afterString
        }
    }
    
    func updateCounter(counterValue: Float) -> Float {
        switch counterAnimationType! {
        case .Linear:
            return counterValue
        case .EaseIn:
            return powf(counterValue, counterVelocity)
        case .EaseOut:
            return 1.0 - powf(1.0-counterValue, counterVelocity)
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
