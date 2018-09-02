//
//  CAAgendaView.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-26.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

protocol CAAgendaDisplayable {
    func topped(date: Date)
    func refreshAgenda(viewModel: CACalendarViewModel)
}

protocol CAAgendaControlable {
    func top(date: Date)
}

class CAAgendaView: UIView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CAAgendaControlable {
    var displayDelegate: CAAgendaDisplayable?
    var tableView: UITableView!
    var viewModel: CAAgendaViewModel = CAAgendaViewModel()
    var selectedDateIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            let selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateIndexPath.section, to: viewModel.minDate)
            displayDelegate?.topped(date: selectedDate!)
        }
    }
    let agendarHeaderViewReuseIdentifier = "CAAgendarHeaderViewReuseIdentifier"
    let agendarCellReuseIdentifier = "CAAgendarTableViewCellReuseIdentifier"
    let agendarEmptyCellReuseIdentifier = "CAAgendarTableViewEmptyCellReuseIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var f = frame
        f.origin = CGPoint(x: 0, y: 0)
        tableView = UITableView(frame: f, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        
        tableView.register(CAAgendaViewHeaderView.self, forHeaderFooterViewReuseIdentifier: agendarHeaderViewReuseIdentifier)
        tableView.register(CAAgendaTableViewCell.self, forCellReuseIdentifier: agendarCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: agendarEmptyCellReuseIdentifier)
        
        // scroll to today
        tableView.scrollToRow(at: IndexPath(row: 0,
                                            section: sectionIndex(ofDate: Date())),
                              at: UITableViewScrollPosition.top,
                              animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentDate = Calendar.current.date(byAdding: .day, value: section, to: viewModel.minDate)
        let eventsForCurDay = viewModel.events(forDate: currentDate!)
        return eventsForCurDay.count > 0 ? eventsForCurDay.count : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let days = Date.daysBetween(fromDate: viewModel.minDate, toDate: viewModel.maxDate)
        return days
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentDate = Calendar.current.date(byAdding: .day, value: indexPath.section, to: viewModel.minDate)
        let eventsForCurDay = viewModel.events(forDate: currentDate!)
        return eventsForCurDay.count > 0 ? Constants.agendaCellHeight : Constants.agendaEmptyCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.agendaHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentDate = Calendar.current.date(byAdding: .day, value: indexPath.section, to: viewModel.minDate)
        let eventsForCurDay = viewModel.events(forDate: currentDate!)
        if  eventsForCurDay.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: agendarEmptyCellReuseIdentifier, for: indexPath)
            
            cell.textLabel?.text = "No Events"
            cell.textLabel?.textColor = Constants.agendaTextColor
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: agendarCellReuseIdentifier, for: indexPath) as! CAAgendaTableViewCell
            let curEvent = eventsForCurDay[indexPath.row]
            
            cell.startTimeLabel.text = curEvent.eventStartTime.timeOfDate()
            cell.eventDurationLabel.text = Date.durationBetween(fromDate: curEvent.eventStartTime, toDate: curEvent.eventEndTime)
            cell.setStickerColor(colorString: curEvent.stickerColor)
            cell.setEventTitleLabel(text: curEvent.eventTitle)
            
            cell.setContactsView(contacts: curEvent.paticipants)
            cell.eventLocation.setTitle(curEvent.eventLocation, for: .normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: agendarHeaderViewReuseIdentifier) as? CAAgendaViewHeaderView
        
        let currentDate = Calendar.current.date(byAdding: .day, value: section, to: viewModel.minDate)
        headerView?.setHeaderText(date: currentDate!)
        return headerView!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return Constants.agendaHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: private method
    
    private func sectionIndex(ofDate: Date) -> Int {
        let days = Date.daysBetween(fromDate: viewModel.minDate, toDate: ofDate)
        return days
    }
    
    // MARK: ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let firstRow = tableView.indexPathsForVisibleRows![0]
//        let currentDate = Calendar.current.date(byAdding: .day, value: firstRow.section, to: viewModel.minDate)
        selectedDateIndexPath = firstRow
    }
    
    
    // enable paging effect
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let firstRow = tableView.indexPathsForVisibleRows![0]
        tableView.scrollToRow(at: firstRow, at: .top, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let firstRow = tableView.indexPathsForVisibleRows![0]
        tableView.scrollToRow(at: firstRow, at: .top, animated: true)
    }
    
    // MARK: CAAgendaDisplayable
    func top(date: Date) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: sectionIndex(ofDate: date)), at: .top, animated: true)
    }
}

extension CAAgendaView {
    struct Constants {
        static let agendaHeaderHeight: CGFloat = 24
        static let agendaCellHeight: CGFloat = 120
        static let agendaEmptyCellHeight: CGFloat = 40
        static let agendaHeaderBackgroundColor = UIColor.hexColor(string:"0xf5fafc")
        static let agendaHeaderTintColor = UIColor.hexColor(string:"0x006bc5")
        static let agendaTextColor = UIColor.hexColor(string:"0x8a8a8f")
    }
}
