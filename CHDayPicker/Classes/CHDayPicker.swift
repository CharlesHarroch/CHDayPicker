//
//  CHDayPicker.swift
//  Pods
//
//  Created by Charles HARROCH on 14/06/2016.
//
//

import UIKit

public protocol CHDayPickerDelegate : class {
    func didSelectDay(position : Int, label : String, selected : Bool)
}

@IBDesignable public class CHDayPicker: UIView {
    
    public weak var delegate : CHDayPickerDelegate?
    
    public var daysLabel  = ["L", "M", "M" , "J", "V", "S", "D"] {
        didSet {
            setupView()
        }
    }
    
    // MARK : IBDesignable Declaration
    
    @IBInspectable var defaultSelectedDay : Int = -1 { didSet { self.selectDayAtPosition(defaultSelectedDay) } }
    @IBInspectable public var singleSelection : Bool = false
    @IBInspectable public var titleColor : UIColor = UIColor.blackColor()
    @IBInspectable public var selectedBackgroundColor : UIColor = UIColor.clearColor()
    @IBInspectable public var titleBackgroundColor : UIColor = UIColor.clearColor()
    @IBInspectable public var selectedTitleColor : UIColor = UIColor.whiteColor()
    
    // MARK : Private property
    private typealias CHButton = (button : UIButton, selected : Bool, selectedLayer : CALayer)
    private var daysButton : [CHButton] = []
    private var selectedButton : [CHButton] = []
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.daysButton.forEach { tuple in
            let itemWidth = CGFloat(self.bounds.width) / CGFloat(daysLabel.count)
            let itemHeight = self.bounds.height
            tuple.button.frame = CGRectMake(CGFloat(tuple.button.tag) * itemWidth, 0, itemWidth, itemHeight)
            let minSize = min(tuple.button.frame.size.width, tuple.button.frame.size.height)
            tuple.selectedLayer.frame = CGRectMake(tuple.button.frame.size.width/2 - minSize/2, tuple.button.frame.size.height/2 - minSize/2 , minSize, minSize)
        }
    }
    
    public func setupView() {
        
        var position = 0
        
        let itemWidth = CGFloat(self.bounds.width) / CGFloat(daysLabel.count)
        let itemHeight = self.bounds.height
        
        daysButton.forEach {$0.button.removeFromSuperview()}
        daysButton.removeAll()
        
        self.daysLabel.forEach { currentDay in
            let button = UIButton(frame: CGRectMake(CGFloat(position) * itemWidth, 0, itemWidth, itemHeight))
            let layer = CALayer()
            let tuple = CHButton(button, false, layer)
            
            configureButton(tuple, title: currentDay, position: position)
            configureLayer(tuple)
            daysButton.append(tuple)
            
            if position == defaultSelectedDay {
                selectDay(button)
            }
            
            position += 1
        }
    }
    
    private func configureButton(tuple : CHButton, title : String, position : Int) {
        tuple.button.setTitle(title, forState: UIControlState.Normal)
        tuple.button.layer.cornerRadius = self.frame.height/2
        tuple.button.setTitleColor(titleColor, forState: .Normal)
        tuple.button.addTarget(self, action: #selector(CHDayPicker.selectDay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        tuple.button.tag = position
        self.addSubview(tuple.button)
    }
    
    private func configureLayer(tuple : CHButton) {
        let minSize = min(tuple.button.frame.size.width, tuple.button.frame.size.height)
        tuple.selectedLayer.frame = CGRectMake(tuple.button.frame.size.width/2 - minSize/2, tuple.button.frame.size.height/2 - minSize/2 , minSize, minSize)
        tuple.selectedLayer.backgroundColor = UIColor.clearColor().CGColor
        tuple.selectedLayer.cornerRadius = minSize/2
        tuple.button.layer.addSublayer(tuple.selectedLayer)
    }
    
    @objc private func selectDay(sender : AnyObject) {
        
        if (singleSelection == true) {
            for (index, element) in daysButton.enumerate() {
                setInActive(daysButton[index])
                daysButton[index].selected = false
            }
        }
        
        daysButton[sender.tag].selected = !daysButton[sender.tag].selected
        
        switch daysButton[sender.tag].selected {
        case true:
            selectDayAtPosition(sender.tag)
        case false :
            deselectDayAtPosition(sender.tag)
        }
        
        self.delegate?.didSelectDay(sender.tag, label: daysLabel[sender.tag], selected: daysButton[sender.tag].selected)

    }
    
    public func selectDayAtPosition(position : Int) {
        self.daysButton[position].selected = true
        self.daysButton[position].button.setTitleColor(selectedTitleColor, forState: .Normal)
        self.daysButton[position].selectedLayer.backgroundColor = selectedBackgroundColor.CGColor
    }
    
    public func deselectDayAtPosition(position : Int) {
        self.daysButton[position].selected = false
        self.daysButton[position].button.setTitleColor(titleColor, forState: .Normal)
        self.daysButton[position].selectedLayer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    private func setActive(tuple : CHButton) {
        tuple.button.setTitleColor(selectedTitleColor, forState: .Normal)
        tuple.selectedLayer.backgroundColor = selectedBackgroundColor.CGColor
        
    }
    
    private func setInActive(tuple : CHButton) {
        tuple.button.setTitleColor(titleColor, forState: .Normal)
        tuple.selectedLayer.backgroundColor = UIColor.clearColor().CGColor
    }
}

extension CHDayPicker {
    
}
