//
//  ViewController.swift
//  DialView
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dialView: DialView!

    override func viewDidLoad() {
        super.viewDidLoad()
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

