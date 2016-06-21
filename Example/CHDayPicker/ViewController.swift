//
//  ViewController.swift
//  CHDayPicker
//
//  Created by Charles HARROCH on 06/14/2016.
//  Copyright (c) 2016 Charles HARROCH. All rights reserved.
//

import UIKit
import CHDayPicker

class ViewController: UIViewController {

    @IBOutlet weak var dayPicker : CHDayPicker!
    @IBOutlet weak var resultLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayPicker.singleSelection = true
        self.dayPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
    }
}

extension ViewController : CHDayPickerDelegate {
    func didSelectDay(position: Int, label: String, selected : Bool) {
        self.resultLabel.text = "\(position) : \(label)"
    }
}

