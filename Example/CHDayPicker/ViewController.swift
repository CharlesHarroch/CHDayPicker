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
        self.dayPicker.singleSelection = false
        self.dayPicker.delegate = self
        self.dayPicker.selectDayAtPosition(position: 0)
        self.dayPicker.selectDayAtPosition(position: 3)
        self.dayPicker.selectDayAtPosition(position: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
    }
}

extension ViewController : CHDayPickerDelegate {
    func didSelectDay(position: Int, label: String, selected : Bool) {
        self.resultLabel.text = "\(position) : \(label)"
    }
}

