//
//  CACalendarCollectionViewCell.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-27.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CACalendarCollectionViewCell: UICollectionViewCell {
    var dayLabel: UILabel!
    var monthLabel: UILabel!
    var dot: UIView!
    private var selectedView: UIView!
    private let selectedColor = UIColor.green
    
    var didSelected: Bool = false {
        didSet {
            selectedView.isHidden = (didSelected == false)
            dayLabel.textColor = Constants.selectedDateTextColor
        }
    }
    
    required init!(coder aDecoder: NSCoder)  {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        selectedView = UIView(frame: frame)
        selectedView.isHidden = true
        selectedView.backgroundColor = Constants.selectedColor
        self.contentView.addSubview(selectedView)
        
        dot = UIView(frame: frame)
        dot.isHidden = true
        dot.backgroundColor = UIColor.black
        self.contentView.addSubview(dot)
        
        dayLabel = UILabel(frame: frame)
        dayLabel.textAlignment = .center;
        dayLabel.textColor = Constants.calendarTextColor
        dayLabel.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(dayLabel)
        
        monthLabel = UILabel(frame: frame)
        monthLabel.isHidden = true
        monthLabel.font = UIFont.boldSystemFont(ofSize: 12)
        monthLabel.textAlignment = .center
        monthLabel.backgroundColor = UIColor.clear
        monthLabel.textColor = Constants.calendarTextColor
        self.contentView.addSubview(monthLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = UIColor.white
        selectedView.isHidden = true
        monthLabel.isHidden = true
        dot.isHidden = true
        dayLabel.text = ""
        dayLabel.textColor = Constants.calendarTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 2
        var f = self.bounds
        let dayWidth: CGFloat = f.size.height / 2
        let monthWidth: CGFloat = f.size.height / 2
        f.origin.x = (f.size.width - dayWidth) / 2
        f.origin.y = (f.size.height - dayWidth) / 2
        f.size.height = dayWidth
        f.size.width = dayWidth
        dayLabel.frame = f
        
        f.origin.x = (self.bounds.size.width - monthWidth) / 2
        f.origin.y = padding
        f.size.width = monthWidth
        f.size.height = dayLabel.frame.origin.y - padding
        monthLabel.frame = f
        
        f.origin.x = (self.bounds.size.width - Constants.dotRadius) / 2
        f.origin.y = self.bounds.size.height - padding * 2 - Constants.dotRadius
        f.size.width = Constants.dotRadius
        f.size.height = Constants.dotRadius
        dot.frame = f
        dot.layer.masksToBounds = true
        dot.layer.cornerRadius = Constants.dotRadius / 2
        
        f = dayLabel.frame
        selectedView.frame = f
        selectedView.layer.masksToBounds = true
        selectedView.layer.cornerRadius = f.size.width / 2
    }
}

extension CACalendarCollectionViewCell {
    struct Constants {
        static let dotRadius: CGFloat = 4
        static let selectedColor = UIColor.hexColor(string: "#008dff")
        static let selectedDateTextColor = UIColor.white
        static let calendarTextColor = UIColor.hexColor(string:"0x8a8a8f")
    }
}
