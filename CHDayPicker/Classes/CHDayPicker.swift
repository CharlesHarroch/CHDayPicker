//
//  CHDayPicker.swift
//  Pods
//
//  Created by Charles HARROCH on 14/06/2016.
//
//

import UIKit

@IBDesignable class CHDayPicker: UIView {
    
    private let daysLabel  = ["L", "M", "M" , "J", "V", "S", "D"]
    private var daysButton : [(button : UIButton, selected : Bool)] = []
    private var selectedButton : [(button : UIButton, selected : Bool)] = []
    
    @IBInspectable var defaultSelectedDay : Int = 0 {
        didSet {
            updateButtons()
        }
    }
    
    @IBInspectable var singleSelection : Bool = false {
        didSet { updateButtons() }
    }
    
    @IBInspectable var titleColor : UIColor = UIColor.blackColor() {
        didSet { updateButtons() }
    }
    
    @IBInspectable var selectedBackgroundColor : UIColor = UIColor.redColor() {
        didSet { updateButtons() }
    }
    
    @IBInspectable var titleBackgroundColor : UIColor = UIColor.clearColor() {
        didSet { updateButtons() }
    }
    
    @IBInspectable var selectedTitleColor : UIColor = UIColor.whiteColor() {
        didSet { updateButtons() }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    
    public func setupView() {
        
        var position = 0
        let itemWidth = (CGFloat(self.bounds.width) / CGFloat(daysLabel.count))
        
        daysButton.forEach {$0.button.removeFromSuperview()}
        daysButton.removeAll()
        
        self.daysLabel.forEach { currentDay in
            let button = UIButton(frame: CGRectMake(CGFloat(position) * itemWidth, 0, itemWidth, itemWidth))
            
            button.setTitle(currentDay, forState: UIControlState.Normal)
            button.layer.cornerRadius = itemWidth/2
            button.setTitleColor(titleColor, forState: .Normal)
            button.addTarget(self, action: #selector(CHDayPicker.selectDayAtPosition(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = position
            self.addSubview(button)
            daysButton.append((button : button, selected : false))
            
            if position == defaultSelectedDay {
                selectDayAtPosition(button)
            }
            
            position += 1
        }
    }
    
    public func selectDayAtPosition(sender : AnyObject) {
        
        if (singleSelection == true) {
            for (index, element) in daysButton.enumerate() {
                setInActive(daysButton[index].button)
                daysButton[index].selected = false
            }
        }
        
        daysButton[sender.tag].selected = !daysButton[sender.tag].selected
        
        switch daysButton[sender.tag].selected {
        case true:
            setActive(daysButton[sender.tag].button)
        case false:
            setInActive(daysButton[sender.tag].button)
        }
    }
    
    func updateButtons() {
        self.daysButton.forEach { selectDayAtPosition($0.button) }
    }
    
    func setActive(button : UIButton) {
        button.backgroundColor = selectedBackgroundColor
        button.setTitleColor(selectedTitleColor, forState: .Normal)
    }
    
    func setInActive(button : UIButton) {
        button.backgroundColor = titleBackgroundColor
        button.setTitleColor(titleColor, forState: .Normal)
    }
}

extension CHDayPicker {
    
}
