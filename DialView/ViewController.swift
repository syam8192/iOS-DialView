//
//  ViewController.swift
//  DialView
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dialView: DialView!


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let halfWidth = dialView.bounds.width / 2
        let div = 24
        for i in 0..<div {
            let f = CGFloat(i) / CGFloat(div)
            let label: UILabel = UILabel()
            label.textColor = UIColor(hue: f, saturation: 1, brightness: 1, alpha: 1)
            label.text = String(format: "%02d", i)
            label.sizeToFit()
            label.center = CGPoint(x: dialView.bounds.midX, y: dialView.bounds.midY)
            label.transform = CGAffineTransform(rotationAngle: 3.1415927 * 2 * f).translatedBy(x: 0, y: label.bounds.height - halfWidth)
            dialView.addSubview(label)
        }
        dialView.layer.borderColor = UIColor.black.cgColor
        dialView.layer.borderWidth = 2
        dialView.layer.cornerRadius = halfWidth
        dialView.roundedHitRadius = halfWidth
        dialView.delegate = self
    }

}


extension ViewController: DialViewDelegate {

    func dialViewDidRotate(_ dialView: DialView) {
//        print("dialViewDidRotate()")
    }
    func dialViewWillBeginDragging(_ dialView: DialView) {
//        print("dialViewWillBeginDragging()")
    }
    func dialViewWillEndDragging(_ dialView: DialView, withAngularVelocity velocity: CGFloat, targetAngle: CGFloat) {
//        print("dialViewWillEndDragging(velocity: \(velocity), targetAngle:\(targetAngle))")
    }
    func dialViewDidEndDragging(_ dialView: DialView, willDecelerate decelerate: Bool) {
//        print("dialViewDidEndDragging(willDecelerate: \(decelerate))")
    }
    func dialViewWillBeginDecelerating(_ dialView: DialView) {
//        print("dialViewWillBeginDecelerating()")
    }
    func dialViewDidEndDecelerating(_ dialView: DialView) {
//        print("dialViewDidEndDecelerating()")
    }

}

