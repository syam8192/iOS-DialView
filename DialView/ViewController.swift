//
//  ViewController.swift
//  DialView
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dialView: DialView!
    @IBOutlet weak var slider: UISlider!

    let european = [0,32,15,19,4,21,2,25,17,34,6,27,13,36,11,30,8,23,10,5,24,16,33,1,20,14,31,9,22,18,29,7,28,12,35,3,26]

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        dialView.stopRotation()
        dialView.subviews.forEach{ $0.removeFromSuperview() }
        
        let halfWidth = dialView.bounds.width / 2
        let div: Int = european.count
        for i in 0..<div {
            let f = CGFloat(i) / CGFloat(div)
            let label: UILabel = UILabel()
            label.backgroundColor = i == 0 ? UIColor.green : ( i % 2 == 0 ? UIColor.black : UIColor.red)
            label.font = UIFont.systemFont(ofSize: halfWidth / 10)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = "\(european[i])"
            label.sizeToFit()
            label.frame.size.width = (2 * halfWidth * 3.1415927) / CGFloat(div)
            label.center = CGPoint(x: dialView.bounds.midX, y: dialView.bounds.midY)
            label.transform = CGAffineTransform(rotationAngle: 3.1415927 * 2 * f).translatedBy(x: 0, y: label.bounds.height - halfWidth)
            dialView.addSubview(label)
            if i % 2 == 0 {
                dialView.sendSubview(toBack: label)
            }
        }

        dialView.layer.borderColor = UIColor.black.cgColor
        dialView.layer.borderWidth = 2
        dialView.layer.cornerRadius = halfWidth
        dialView.roundedHitRadius = halfWidth
        dialView.stickeyPointInterval = 3.1415927 * 2 / CGFloat(div)
        dialView.delegate = self
        
        onDidSlide(slider: slider)
    }

    @IBAction func onDidSlide(slider: UISlider) {
        dialView.stopRotation()
        dialView.angleDecelerator.decelerationRate = CGFloat(slider.value * slider.value)
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

