//
//  CAAgendaViewHeaderView.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-31.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CAAgendaViewHeaderView: UITableViewHeaderFooterView {
    private var dateLabel: UILabel!
    private var dividerTop: UIView!
    private var dividerBottom: UIView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = Constants.agendaHeaderBackgroundColor
        
        var f = self.bounds
        f.origin.x = Constants.headerPadding
        f.size.width -= Constants.headerPadding
        dateLabel = UILabel(frame: f)
        dateLabel.lineBreakMode = .byTruncatingTail
        dateLabel.textColor = Constants.agendaHeaderTintColor
        self.contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1, constant: -Constants.headerPadding).isActive = true
        
        // divider view
        f = self.bounds
        f.size.height = 1
        f.origin.y = f.maxY - 1
        dividerBottom = UIView(frame: f)
        dividerBottom.backgroundColor = Constants.agendaHeaderBackgroundColor
        dividerBottom.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.contentView.addSubview(dividerBottom)
        
        f.origin.y = 0
        dividerTop = UIView(frame: f)
        dividerTop.backgroundColor = Constants.agendaHeaderBackgroundColor
        dividerTop.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.contentView.addSubview(dividerTop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.backgroundColor = Constants.agendaHeaderBackgroundColor
        dateLabel.textColor = Constants.agendaHeaderTintColor
        dividerBottom.backgroundColor = Constants.agendaHeaderBackgroundColor
        dividerTop.backgroundColor = Constants.agendaHeaderBackgroundColor
    }
    
    public func setHeaderText(date: Date) {
        let dayDiff = Date.daysBetween(fromDate: Date(), toDate: date)
        var extraString = ""
        switch dayDiff {
        case -1:
            extraString = "YESTERDAY · "
            break
        case 0:
            extraString = "TODAY · "
            self.contentView.backgroundColor = Constants.agendaHeaderTodayBackgroundColor
            dividerTop.backgroundColor = Constants.agendaHeaderTodayDividerColor
            dividerBottom.backgroundColor = Constants.agendaHeaderTodayDividerColor
            dateLabel.textColor = Constants.agendaHeaderTodayTintColor
            break
        case 1:
            extraString = "TOMORROW · "
            break
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString.init(string: extraString, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let dateString = NSAttributedString.init(string: date.EEEEMMMMMddString().uppercased(), attributes: [.font: UIFont.systemFont(ofSize: 14)])
        attributedString.append(dateString)
        
        dateLabel.attributedText = attributedString
    }
    
    
}

extension CAAgendaViewHeaderView {
    struct Constants {
        static let headerPadding: CGFloat = 16
        static let agendaHeaderBackgroundColor = UIColor.hexColor(string:"0xf8f8f8")
        static let agendaHeaderTodayBackgroundColor = UIColor.hexColor(string:"0xf5fafc")
        static let agendaHeaderTintColor = UIColor.hexColor(string:"0x8a8a8f")
        static let agendaHeaderTodayTintColor = UIColor.hexColor(string:"0x006bc5")
        static let agendaHeaderTodayDividerColor = UIColor.hexColor(string:"0xe4f0f9")
    }
}
