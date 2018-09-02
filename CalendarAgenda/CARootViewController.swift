//
//  CARootViewController.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-25.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CARootViewController: UIViewController {
    var calendarView: CACalendarView!
    var agendaView: CAAgendaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        var f = self.view.frame
        // calendar
        let lineSpacing: CGFloat = 1
        f.size.height = CACalendarView.Constants.calendarTitleViewHeight + floor(f.size.width / 7) * 5 + 5 * lineSpacing
        calendarView = CACalendarView(frame: f)
        calendarView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.view.addSubview(calendarView)
        
        f.origin.y = f.maxY + 1
        f.size.height = self.view.frame.size.height - f.size.height
        agendaView = CAAgendaView(frame: f)
        agendaView.autoresizingMask = [.flexibleHeight]
        self.view.addSubview(agendaView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
