//
//  ValueDecelerator.swift
//  DialView
//

import UIKit

typealias DecelerationAnimationProcedure = (_ value: CGFloat, _ finished: Bool) -> (Bool)

class ValueDecelerator {
    
    var value: CGFloat = 0
    var initialVelocity: CGFloat = 0
    var initialValue: CGFloat = 0
    var initialTime: TimeInterval = 0
    var targetValue: CGFloat = 0
    var targetTime: CGFloat = 0
    var decelerationRate: CGFloat = 10
    var maxValue: CGFloat = 200
    var minValue: CGFloat = 0.01
    var procedure: DecelerationAnimationProcedure?
    var stickeyPointInterval: CGFloat = 0
    
    private var deceleration: CGFloat = 0
    private var displayLink: CADisplayLink?
    
    func deceleration(initialValue value: CGFloat, velocity: CGFloat, update: @escaping DecelerationAnimationProcedure) {
        initialValue = value
        initialVelocity = velocity
        procedure = update
        initialTime = NSDate().timeIntervalSince1970
        targetTime = abs(initialVelocity / decelerationRate)
        deceleration = initialVelocity > 0 ? -decelerationRate : decelerationRate
        targetValue = initialValue + initialVelocity * targetTime + (deceleration * targetTime * targetTime / 2)
        if stickeyPointInterval > 0 {
            targetValue = round(targetValue / stickeyPointInterval) * stickeyPointInterval
            deceleration = (targetValue - initialValue - initialVelocity * targetTime ) * 2 / (targetTime * targetTime)
        }
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(ValueDecelerator.animationUpdate))
            displayLink?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        }
    }

    func stop(needsLastUpdate: Bool = false) {
        if needsLastUpdate {
            animationUpdate(stop: true)
        }
        else {
            stopUpdating()
        }
    }
    @objc func animationUpdate(stop: Bool = false) {
        let t = CGFloat(NSDate().timeIntervalSince1970 - initialTime)
        let finished = CGFloat(targetTime) < t
        value = finished ? targetValue : initialValue + initialVelocity * t + (deceleration * t * t / 2)
        if !(procedure?(value, finished) ?? true) || finished || stop {
            stopUpdating()
        }
    }
    private func stopUpdating() {
        displayLink?.invalidate()
        displayLink = nil
    }

}
