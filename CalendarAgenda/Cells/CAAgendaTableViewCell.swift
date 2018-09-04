//
//  CAAgendaTableViewCell.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-29.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CAAgendaTableViewCell: UITableViewCell {
    var startTimeLabel: UILabel!
    var eventDurationLabel: UILabel!
    var stickerView: UIView!
    var eventTitleLabel: UILabel!
    var eventLocation: UIButton!
    var stackView: UIStackView!
    var contactsView: UIView!
    var contactsViews: [UIImageView] = []
    var eventTitleHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        stickerView.backgroundColor = Constants.stickerDefaultColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        stickerView.backgroundColor = Constants.stickerDefaultColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startTimeLabel.text = ""
        eventDurationLabel.text = ""
        eventTitleLabel.text = ""
        eventLocation.setTitle("", for: .normal)
        contactsView.isHidden = true
        stickerView.backgroundColor = Constants.stickerDefaultColor
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // start time label
        startTimeLabel = UILabel()
        startTimeLabel.font = Constants.labelFont
        startTimeLabel.textColor = Constants.agendaTextColor
        self.contentView.addSubview(startTimeLabel)
        
        // duration label
        eventDurationLabel = UILabel()
        eventDurationLabel.font = Constants.labelFont
        eventDurationLabel.textColor = Constants.agendaTextColor
        self.contentView.addSubview(eventDurationLabel)
        
        // sticker view
        stickerView = UIView()
        stickerView.backgroundColor = Constants.stickerDefaultColor
        self.addSubview(stickerView)
        
        // stack view - title, contacts, location
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = Constants.verticalPadding
        stackView.autoresizingMask = .flexibleWidth
        self.contentView.addSubview(stackView)
        
        // Title
        eventTitleLabel = UILabel()
        eventTitleLabel.numberOfLines = 0
        eventTitleLabel.textColor = Constants.agendaTextColor
        eventTitleLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(eventTitleLabel)
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        eventTitleHeightConstraint = eventTitleLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        eventTitleHeightConstraint.isActive = true
        
        // Contacts
        contactsView = UIView()
        
        var f = CGRect(x: 0,
                       y: 0,
                       width: Constants.contactRadius,
                       height: Constants.contactRadius)
        for _ in 0 ..< Constants.maxContactNumber {
            let contactView = UIImageView(frame: f)
            contactView.layer.masksToBounds = true
            contactView.layer.cornerRadius = Constants.contactRadius / 2
            
            contactsViews.append(contactView)
            contactsView.addSubview(contactView)
            
            f.origin.x = f.maxX + Constants.contactsHonrizontalPadding
        }
        stackView.addArrangedSubview(contactsView)
        contactsView.translatesAutoresizingMaskIntoConstraints = false
        contactsView.heightAnchor.constraint(equalToConstant: Constants.contactRadius).isActive = true
        
        // location
        eventLocation = UIButton()
        eventLocation.setImage(#imageLiteral(resourceName: "locationIcon"), for: .normal)
        eventLocation.titleLabel?.font = Constants.labelFont
        eventLocation.titleLabel?.lineBreakMode = .byTruncatingTail
        eventLocation.contentHorizontalAlignment = .left
        eventLocation.setTitleColor(UIColor.lightGray, for: .normal)
        eventLocation.isUserInteractionEnabled = false
        eventLocation.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
        stackView.addArrangedSubview(eventLocation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // start time label
        var f = self.bounds
        f.origin.x = Constants.honrizontalPadding
        f.origin.y = Constants.verticalPadding
        f.size.width = Constants.timeLabelWidth
        f.size.height = Constants.labelHeight
        startTimeLabel.frame = f
        
        // duration label
        f.origin.y += f.size.height + Constants.verticalPadding
        eventDurationLabel.frame = f
        
        // sticker view
        f.origin.x = startTimeLabel.frame.maxX + Constants.honrizontalPadding
        f.origin.y = Constants.stickerVerPadding
        f.size.width = Constants.stickerRadius
        f.size.height = Constants.stickerRadius
        stickerView.frame = f
        stickerView.layer.masksToBounds = true
        stickerView.layer.cornerRadius = f.size.width / 2
        
        // stack view - title, contacts, location
        f.origin.x = stickerView.frame.maxX + Constants.honrizontalPadding
        f.origin.y = Constants.verticalPadding
        f.size.width = self.bounds.size.width - f.origin.x - Constants.honrizontalPadding
        f.size.height = self.bounds.size.height - Constants.verticalPadding * 2
        stackView.frame = f
        
        let height = eventTitleLabelHeight(width: f.size.width, text: eventTitleLabel.text!)
        eventTitleHeightConstraint.constant = height
    }
    
    // MARK: Public Methods
    func setContactsView(contacts: [CAContacts]) {
        if contacts.count == 0 {
            contactsView.isHidden = true
        } else {
            for i in 0..<Constants.maxContactNumber {
                let imageView = contactsViews[i]
                if i < contacts.count {
                    imageView.image = UIImage(named: contacts[i].userIcon)
                    imageView.isHidden = false
                } else {
                    imageView.isHidden = true
                }
            }
            contactsView.isHidden = false
        }
    }
    
    func setStickerColor(colorString: String) {
        if colorString.count != 0 {
            stickerView.backgroundColor = UIColor.red
        }
    }
    
    func setEventTitleLabel(text: String) {
        eventTitleLabel.text = text
    }
}

extension CAAgendaTableViewCell {
    struct Constants {
        static let verticalPadding: CGFloat = 10
        static let stickerVerPadding: CGFloat = 16
        static let honrizontalPadding: CGFloat = 16
        static let contactsHonrizontalPadding: CGFloat = 6
        static let contactRadius: CGFloat = 20
        static let timeLabelWidth: CGFloat = 70
        static let stickerRadius: CGFloat = 12
        static let labelHeight: CGFloat = 21
        
        static let maxContactNumber: Int = 3
        
        static let labelFont = UIFont.systemFont(ofSize: 14)
        static let stickerDefaultColor = UIColor.hexColor(string: "0xff9900")
        static let agendaTextColor = UIColor.hexColor(string:"0x8a8a8f")
    }
    
    private func eventTitleLabelHeight(width: CGFloat, text: String) -> CGFloat {
        var f = eventTitleLabel.frame
        f.size.width = width
        f.size.height = CGFloat.greatestFiniteMagnitude
        
        let newLabel = UILabel(frame: f)
        newLabel.numberOfLines = eventTitleLabel.numberOfLines
        newLabel.lineBreakMode = eventTitleLabel.lineBreakMode
        newLabel.font = eventTitleLabel.font
        newLabel.text = text
        newLabel.sizeToFit()
        
        if newLabel.frame.size.height > Constants.labelHeight {
            return Constants.labelHeight * 2
        }
        return Constants.labelHeight
    }
}
