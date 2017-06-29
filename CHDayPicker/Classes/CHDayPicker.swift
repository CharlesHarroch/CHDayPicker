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
    
    public var daysLabel  = ["S", "M", "T" , "W", "T", "F", "S"] {
        didSet {
            setupView()
        }
    }
    
    // MARK : IBDesignable Declaration
    
    @IBInspectable public var defaultSelectedDay : Int = -1
    @IBInspectable public var singleSelection : Bool = false
    @IBInspectable public var titleColor : UIColor = UIColor.black
    @IBInspectable public var selectedBackgroundColor : UIColor = UIColor.clear
    @IBInspectable public var selectedTitleColor : UIColor = UIColor.white
    
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
    }
    
    public func setupView() {
        
        var position = 0
        
        let itemWidth = CGFloat(self.bounds.width) / CGFloat(daysLabel.count)
        let itemHeight = self.bounds.height
        
        daysButton.forEach {$0.button.removeFromSuperview()}
        daysButton.removeAll()
        
        self.daysLabel.forEach { currentDay in
            let button = UIButton(frame: CGRect(x: CGFloat(position) * itemWidth, y:0, width: itemWidth, height: itemHeight))
            let layer = CALayer()
            let tuple = CHButton(button, false, layer)
            
            configureButton(tuple: tuple, title: currentDay, position: position)
            configureLayer(tuple: tuple)
            daysButton.append(tuple)
            
            if position == defaultSelectedDay {
                selectDay(sender: button)
            }
            
            position += 1
        }
    }
    
    private func configureButton(tuple : CHButton, title : String, position : Int) {
        tuple.button.setTitle(title, for: UIControlState.normal)
        tuple.button.layer.cornerRadius = self.frame.height/2
        if self.defaultSelectedDay == position {
            tuple.button.setTitleColor(selectedTitleColor, for: .normal)
        } else {
            tuple.button.setTitleColor(titleColor, for: .normal)
        }
        tuple.button.addTarget(self, action: #selector(CHDayPicker.selectDay(sender:)), for: UIControlEvents.touchUpInside)
        tuple.button.tag = position
        self.addSubview(tuple.button)
    }
    
    private func configureLayer(tuple : CHButton) {
        let minSize = min(tuple.button.frame.size.width, tuple.button.frame.size.height)
        tuple.selectedLayer.frame = CGRect(x: tuple.button.frame.size.width/2 - minSize/2, y: tuple.button.frame.size.height/2 - minSize/2 , width: minSize, height: minSize)
        tuple.selectedLayer.backgroundColor = UIColor.clear.cgColor
        tuple.selectedLayer.cornerRadius = minSize/2
        tuple.button.layer.addSublayer(tuple.selectedLayer)
    }
    
    @objc private func selectDay(sender : AnyObject) {
        
        if (singleSelection == true) {
            for (index, _) in daysButton.enumerated() {
                setInActive(tuple: daysButton[index])
                daysButton[index].selected = false
            }
        }
        
        daysButton[sender.tag].selected = !daysButton[sender.tag].selected
        
        switch daysButton[sender.tag].selected {
        case true:
            selectDayAtPosition(position: sender.tag)
        case false :
            deselectDayAtPosition(position: sender.tag)
        }
        self.delegate?.didSelectDay(position: sender.tag, label: daysLabel[sender.tag], selected: daysButton[sender.tag].selected)
    }
    
    public func selectDayAtPosition(position : Int) {
        if self.daysButton.count > position && position >= 0{
            self.daysButton[position].selected = true
            self.daysButton[position].button.setTitleColor(selectedTitleColor, for: .normal)
            self.daysButton[position].selectedLayer.backgroundColor = selectedBackgroundColor.cgColor
        }
    }
    
    public func deselectDayAtPosition(position : Int) {
        if self.daysButton.count >= position {
            self.daysButton[position].selected = false
            self.daysButton[position].button.setTitleColor(titleColor, for: .normal)
            self.daysButton[position].selectedLayer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    private func setActive(tuple : CHButton) {
        tuple.button.setTitleColor(selectedTitleColor, for: .normal)
        tuple.selectedLayer.backgroundColor = selectedBackgroundColor.cgColor
        
    }
    
    private func setInActive(tuple : CHButton) {
        tuple.button.setTitleColor(titleColor, for: .normal)
        tuple.selectedLayer.backgroundColor = UIColor.clear.cgColor
    }
}
