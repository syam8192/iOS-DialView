//
//  DialView.swift
//  DialView
//

import UIKit


class DialView: UIView {

    // 角度(rad).
    var angle: CGFloat = 0
    // 角速度（rad/sec）.
    var angularVelocity: CGFloat = 0
    // これ以上速くさせない.
    var maxAngularVelocity: CGFloat = 200
    // view内のタッチ判定をアンカーポイントからの距離で限定する. 0 以下で無効.
    var roundedHitRadius: CGFloat = 0
    // タッチを放したときに慣性で回転を始める角速度の下限.
    var decelerateThreshold: CGFloat = 1

    var delegate: DialViewDelegate?

    private var previousPoint: CGPoint = CGPoint.zero
    private var previousTime: TimeInterval = 0
    private var angleDecelerator: ValueDecelerator = ValueDecelerator()
    private var isDragging: Bool = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        transform = CGAffineTransform.identity
        previousPoint = touches.first?.location(in: self) ?? CGPoint.zero
        previousTime = NSDate().timeIntervalSince1970
        angularVelocity = 0
        angleDecelerator.stop()
        isDragging = false
        transform = CGAffineTransform(rotationAngle: angle)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        transform = CGAffineTransform.identity
        let nowTime: TimeInterval = NSDate().timeIntervalSince1970
        let point = touches.first?.location(in: self) ?? CGPoint.zero
        let vx0 = point.x - previousPoint.x
        let vy0 = point.y - previousPoint.y
        let vx1 = bounds.width * layer.anchorPoint.x - previousPoint.x
        let vy1 = bounds.height * layer.anchorPoint.y - previousPoint.y
        let velocity = min(max(-maxAngularVelocity,  (vx0 * vy1 - vx1 * vy0) / (vx1 * vx1 + vy1 * vy1)), maxAngularVelocity)
        angularVelocity = velocity / CGFloat(nowTime - previousTime)
        previousTime = nowTime
        previousPoint = point
        update(newAngle: angle + velocity)

        if !isDragging { delegate?.dialViewWillBeginDragging(self) }
        isDragging = true
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isDragging = false
        let willDecelerate: Bool = abs(angularVelocity) > decelerateThreshold
        if willDecelerate {
            angleDecelerator.deceleration(initialValue: angle, velocity: angularVelocity) { value, finished in
                self.update(newAngle: value)
                if finished {
                    self.delegate?.dialViewDidEndDecelerating(self)
                }
                return true
            }
            delegate?.dialViewWillEndDragging(self, withAngularVelocity: angularVelocity, targetAngle: angleDecelerator.targetValue)
        }
        else {
            angularVelocity = 0
        }
        delegate?.dialViewDidEndDragging(self, willDecelerate: willDecelerate)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isDragging = false
        angularVelocity = 0
        angleDecelerator.stop()
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = super.hitTest(point, with: event)
        if v == self && roundedHitRadius > 0 {
            let dx = bounds.width * layer.anchorPoint.x - point.x
            let dy = bounds.height * layer.anchorPoint.y - point.y
            if dx * dx + dy * dy > roundedHitRadius * roundedHitRadius {
                return nil
            }
        }
        return v
    }

    private func update(newAngle: CGFloat) {
        angle = newAngle
        transform = CGAffineTransform(rotationAngle: newAngle)
        delegate?.dialViewDidRotate(self)
    }
}

// UIScrollViewDelegate と同様.
protocol DialViewDelegate {
    func dialViewDidRotate(_ dialView: DialView)
    func dialViewWillBeginDragging(_ dialView: DialView)
    func dialViewWillEndDragging(_ dialView: DialView, withAngularVelocity velocity: CGFloat, targetAngle: CGFloat)
    func dialViewDidEndDragging(_ dialView: DialView, willDecelerate decelerate: Bool)
    func dialViewWillBeginDecelerating(_ dialView: DialView)
    func dialViewDidEndDecelerating(_ dialView: DialView)
}

extension DialViewDelegate {
    func dialViewDidRotate(_ dialView: DialView) {}
    func dialViewWillBeginDragging(_ dialView: DialView) {}
    func dialViewWillEndDragging(_ dialView: DialView, withAngularVelocity velocity: CGFloat, targetAngle: CGFloat) {}
    func dialViewDidEndDragging(_ dialView: DialView, willDecelerate decelerate: Bool) {}
    func dialViewWillBeginDecelerating(_ dialView: DialView) {}
    func dialViewDidEndDecelerating(_ dialView: DialView) {}
    func dialViewDidEndScrollingAnimation(_ dialView: DialView) {}
}
