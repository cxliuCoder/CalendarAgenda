//
//  CARootViewController.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-25.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CARootViewController: UIViewController, CACalendarDisplayable, CAAgendaDisplayable {
    
    var calendarView: CACalendarView!
    var agendaView: CAAgendaView!
    var presenter: CAPresenter!
    var addEventButton: UIBarButtonItem!
    
    convenience init(presenter: CAPresenter) {
        self.init()
        self.presenter = presenter
    }
    
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
        presenter.calendarViewControlable = calendarView
        calendarView.displayDelegate = self
        
        // agenda
        f.origin.y = f.maxY + 1
        f.size.height = self.view.frame.size.height - f.size.height
        agendaView = CAAgendaView(frame: f)
        agendaView.autoresizingMask = [.flexibleHeight]
        self.view.addSubview(agendaView)
        presenter.agendaViewControlable = agendaView
        agendaView.displayDelegate = self
        
        presenter.reloadData()
        
        // floating weather button
        
        
        
        // add event button
        addEventButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addARandomEvent))
        addEventButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(addEventButton, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.selectToday()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func addARandomEvent() {
        CAEventDataManager.sharedInstance.addRandomEvent()
        presenter.reloadData()
    }
    
    
    private func setNavTitle(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let title = dateFormatter.string(from: date)
        self.navigationItem.title = title
    }
    
    // MARK: CACalendarDisplayable
    
    func didSelected(date: Date) {
        agendaView.top(date: date)
    }
    
    func didMoveToMonth(date: Date) {
        setNavTitle(date)
    }
    
    // MARK: CAAgendaDisplayable
    
    func topped(date: Date) {
        calendarView.showSelect(date: date)
    }
    
    func didChangedMonth(date: Date) {
        setNavTitle(date)
    }
}
