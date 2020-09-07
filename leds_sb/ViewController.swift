//
//  ViewController.swift
//  leds_sb
//
//  Created by Georg Schwarz on 25.02.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var ipTextView: UITextField!
    @IBOutlet weak var btnSettingsOk: UIButton!
    @IBOutlet weak var leftRightBtn: UIButton!
    @IBOutlet weak var topDownBtn: UIButton!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var btnOnOff: UIButton!
    @IBOutlet weak var btnMod: UIButton!
    @IBOutlet weak var btnOneColoring: UIButton!
    @IBOutlet weak var btnGradient: UIButton!
    @IBOutlet weak var btnSelectedColoring: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var dot1: UIImageView!
    @IBOutlet weak var dot2: UIImageView!
    @IBOutlet weak var grad2Btn: UIButton!
    @IBOutlet weak var grad1Btn: UIButton!
    
    var defaultHost = "http://192.168.2.101:7070"
    
    var kallax = Kallax()
    var colorViewDiff = CGFloat(0)
    let colorViewCornerRadius = CGFloat(20)
    let colorViewAnimDuration = TimeInterval(0.2)
    
    var applyDirectly = true
    
    var request = Request()
    
    var currentMode = PickerMode.OFF
    var cellsSelectable = false
    var kallaxOn = true
    
    var gradMode = GradientMode.TopBottom
    var gradSelect = 1
    
    let colorChangeInterval = 250
    var colorLastChanged = Date().currentTimeMillis()
    var lastColor: UIColor = UIColor.white
    
     var colorSpace: HRColorSpace = .sRGB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = self.colorViewCornerRadius;
        colorView.layer.masksToBounds = true;
        arrowView.isHidden = true
        colorViewDiff = self.colorView.bounds.height - colorViewCornerRadius
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        kallax.setView(collectionView: collectionView, cellIdentifier: "cell")
        colorView.center.y += self.colorView.bounds.height

        colorPicker.addTarget(self, action: #selector(self.handleColorChanged(picker:)), for: .valueChanged)
        colorPicker.set(color: UIColor(displayP3Red: 1.0, green: 1.0, blue: 0, alpha: 1), colorSpace: colorSpace)
        handleColorChanged(picker: colorPicker)
        
        leftRightBtn.isHidden = true
        topDownBtn.isHidden = true
        settingsView.isHidden = true
        ipTextView.text = defaultHost
        request.setHost(newHost: defaultHost)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        kallax.calcCells()
    }
    
    @objc func handleColorChanged(picker: ColorPicker) {
        changeColor(color: picker.color, immediately: false)
    }
    
    func changeKallax(color: UIColor) {
        switch currentMode {
        case .ALL:
            kallax.colorCellsAll(color: color)
            break;
        case .INDIV:
            kallax.colorCellsSelected(color: color)
            break;
        case .GRAD:
            if(gradSelect == 1) {
                grad1Btn.backgroundColor = color
            }else {
                grad2Btn.backgroundColor = color
            }
            kallax.colorCellsGradient(color1: grad1Btn.backgroundColor!, color2: grad2Btn.backgroundColor!, mode: gradMode)
            break;
        default:
            break;
        }
    }
    
    func changeColor(color: UIColor, immediately: Bool = false) {
        changeKallax(color: color)
        lastColor = color
        if(!applyDirectly) {
            return;
        }
        let now = Date().currentTimeMillis()
        if(!immediately && (now - colorLastChanged < colorChangeInterval)) {
            return;
        }
        colorLastChanged = now;
        
        switch currentMode {
        case .ALL:
            request.sendFullColor(colorHex: color.toHex()!)
            break;
        default:
            break;
        }
    }

    
    @IBAction func grad2Clicked(_ sender: Any) {
        gradSelect = 2
        dot1.isHidden = true
        dot2.isHidden = false
    }
    @IBAction func grad1Clicked(_ sender: Any) {
        gradSelect = 1
        dot1.isHidden = false
        dot2.isHidden = true
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        if(!cellsSelectable) {
            return
        }
        if(gesture.state == UIGestureRecognizer.State.ended) {
            let translation = gesture.location(in: self.kallax.collectionView)
            kallax.panEnded(point: translation)
        }else if(gesture.state == UIGestureRecognizer.State.began){
            let translation = gesture.location(in: self.kallax.collectionView)
            kallax.panStarted(point: translation)
        } else {
            let translation = gesture.location(in: self.kallax.collectionView)
            kallax.panOverCell(point: translation)
        }
        gesture.setTranslation(.zero, in: view)
    }
    
    @IBAction func selectAllClicked(_ sender: Any) {
        kallax.selectAll()
    }
    @IBAction func settingsBtnClicked(_ sender: Any) {
        settingsView.isHidden = false
    }
    
    @IBAction func settingsOkClicked(_ sender: Any) {
        let host = ipTextView.text!
        ipTextView.resignFirstResponder()
        request.setHost(newHost: host)
        settingsView.isHidden = true
    }
    
    @IBAction func selectTop(_ sender: Any) {
        kallax.selectTop()
    }
    
    @IBAction func selectBottom(_ sender: Any) {
        kallax.selectBottom()
    }
    
    @IBAction func selectLeft(_ sender: Any) {
        kallax.selectLeft()
    }
    
    @IBAction func selectRight(_ sender: Any) {
        kallax.selectRight()
    }
    
     @IBAction func applyChangesSwitched( sender: UISwitch) {
        applyDirectly = sender.isOn
        if(applyDirectly) {
            changeColor(color: lastColor, immediately: true)
        }
     }
    
     @IBAction func doneBtnClicked(_ sender: Any) {
        currentMode = PickerMode.OFF
        hideColorPicker()
     }
    
     @IBAction func onOffClicked(_ sender: Any) {
        if(kallaxOn) {
            kallax.colorCellsAll(color: UIColor.white)
            request.sendOn()
            btnOnOff.setTitle("Turn Off", for: .normal)
        }else {
            request.sendOff()
            kallax.colorCellsAll(color: UIColor.black)
            btnOnOff.setTitle("Turn On", for: .normal)
        }
        kallaxOn = !kallaxOn
     }
    
    @IBAction func topDownBtnClicked(_ sender: Any) {
        gradMode = .LeftRight
        leftRightBtn.isHidden = false
        topDownBtn.isHidden = true
    }
    
    @IBAction func leftRightBtnClicked(_ sender: Any) {
        gradMode = .TopBottom
        leftRightBtn.isHidden = true
        topDownBtn.isHidden = false
    }
    
     @IBAction func modeClicked(_ sender: Any) {
        currentMode = PickerMode.PATTERN
        showColorPicker()
     }
     @IBAction func allColorsClicked(_ sender: Any) {
         currentMode = PickerMode.ALL
         showColorPicker()
     }
     @IBAction func individualColorClicked(_ sender: Any) {
         currentMode = PickerMode.INDIV
         showColorPicker()
     }
     @IBAction func gradientClicked(_ sender: Any) {
         currentMode = PickerMode.GRAD
         showColorPicker()
     }
    
    func hideColorPicker() {
        UIView.animate(withDuration: self.colorViewAnimDuration, delay: 0.0, options: [], animations: {
            self.colorView.center.y += self.colorViewDiff

        }, completion: nil)
        cellsSelectable = false
        arrowView.isHidden = true
        grad1Btn.isHidden = true
        grad2Btn.isHidden = true
        grad1Btn.backgroundColor = UIColor.black
        grad2Btn.backgroundColor = UIColor.black
        kallax.deselectAll()
    }
    
    func showColorPicker() {
        UIView.animate(withDuration: self.colorViewAnimDuration, delay: 0.0, options: [], animations: {
            self.colorView.center.y -= self.colorViewDiff
        }, completion: nil)
        
        grad1Btn.isHidden = true
        grad2Btn.isHidden = true
        dot1.isHidden = true
        dot2.isHidden = true
        leftRightBtn.isHidden = true
        
        if(currentMode == PickerMode.INDIV || currentMode == PickerMode.PATTERN  || currentMode == PickerMode.GRAD) {
            cellsSelectable = true
            arrowView.isHidden = false
            if(currentMode == .GRAD) {
                grad1Btn.isHidden = false
                grad2Btn.isHidden = false
                gradSelect = 1
                dot1.isHidden = false
                dot2.isHidden = true
                leftRightBtn.isHidden = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kallax.collectionView(collectionView, numberOfItemsInSection: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return kallax.collectionView(collectionView, cellForItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!cellsSelectable) {
            return
        }
        return kallax.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {        if(!cellsSelectable) {
            return
        }
        return kallax.collectionView(collectionView, didHighlightItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {        if(!cellsSelectable) {
            return
        }
        return kallax.collectionView(collectionView, didUnhighlightItemAt: indexPath)
    }


}

extension UIColor {
    func toHex() -> String? {
        let components = cgColor.components
        var r: CGFloat = components?[0] ?? 0.0
        var g: CGFloat = components?[1] ?? 0.0
        var b: CGFloat = components?[2] ?? 0.0
        
        func bounds(val: CGFloat) -> CGFloat {
            if(val < 0) {
                return 0
            }
            if(val > 1) {
                return 1
            }
            return val
        }
        
        r = bounds(val: r)
        g = bounds(val: g)
        b = bounds(val: b)
        

        let hexString = String.init(format: "%02lX%02lX%02lX", lroundf(Float(g * 255)), lroundf(Float(r * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
    
}


extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
