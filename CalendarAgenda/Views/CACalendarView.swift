//
//  CACalendarView.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-26.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

protocol calendarControlable {
    func didSelectedDate()
}

protocol calendarDisplayable {
    func refreshCalendar(viewModel: CACalendarViewModel)
}

class CACalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var controlDelegate: calendarControlable?
    var displayDelegate: calendarDisplayable?
    var viewModel: CACalendarViewModel = CACalendarViewModel()
    var headerView: UIView!
    var dateCollectionView: UICollectionView!
    var selectedDateIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            dateCollectionView.reloadItems(at: [oldValue, selectedDateIndexPath])
            controlDelegate?.didSelectedDate()
        }
    }
    let titleReuseIdentifier = "CACalendarTitleIndentifier"
    let dateReuseIdentifier = "CACalendarDateCollectionViewCellIndentifier"
    
    override init(frame: CGRect) {
        // to avoid item gap between each date, trimming the calendat width to diviable by 7 (days)
        var f = frame
        f.size.width = floor(f.size.width / 7) * 7
        
        super.init(frame: f)
        self.backgroundColor = UIColor.white
        
        // Sticky header
        f.size.height = Constants.calendarTitleViewHeight
        headerView = calendarHeaderView(frame: f)
        headerView.autoresizingMask = .flexibleBottomMargin
        self.addSubview(headerView)
        
        f.origin.y = headerView.frame.size.height + 1
        f.size.height = frame.size.height - headerView.frame.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        dateCollectionView = UICollectionView(frame: f, collectionViewLayout: layout)
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        dateCollectionView.backgroundColor = Constants.calendarDividerColor
        
        dateCollectionView.autoresizingMask = .flexibleTopMargin
        dateCollectionView.showsVerticalScrollIndicator = false
        dateCollectionView.bounces = false
        self.addSubview(dateCollectionView)
        
        dateCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: titleReuseIdentifier)
        dateCollectionView.register(CACalendarCollectionViewCell.self, forCellWithReuseIdentifier: dateReuseIdentifier)
        
        // init selected date to today
        selectedDateIndexPath = IndexPath(row: index(ofDate: Date()), section: 0)
        
        // scroll to today
        dateCollectionView.scrollToItem(at: selectedDateIndexPath, at: .centeredVertically, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private method
    
    private func calendarHeaderView(frame: CGRect) -> UIView {
        let headerView = UIView(frame: frame)
        
        var f = frame
        // bottom divider
        f.origin.y = f.size.height
        f.size.height = 1
        let divider = UIView(frame: f)
        divider.backgroundColor = Constants.calendarDividerColor
        headerView.addSubview(divider)
        
        // weekday titles
        f = headerView.frame
        let titleWidth = f.size.width / 7
        f.size.height = 20
        f.size.width = titleWidth
        f.origin.x = 0
        f.origin.y = (frame.size.height - f.size.height) / 2
        for title in viewModel.weekDayTitle {
            let titleLabel = UILabel(frame: f)
            titleLabel.text = title
            titleLabel.textAlignment = .center;
            f.origin.x += titleWidth
            headerView.addSubview(titleLabel)
        }
        return headerView
    }
    
    private func index(ofDate:Date) -> Int {
        let weekdayOfMinDate = Date.weekDay(fromDate: viewModel.minDate)
        let days = Date.daysBetween(fromDate: viewModel.minDate, toDate: ofDate)
        return days + weekdayOfMinDate - 1
    }
    
    private func date(index: Int) -> Date {
        let weekdayOfMinDate = Date.weekDay(fromDate: viewModel.minDate)
        let currentDate = Calendar.current.date(byAdding: .day, value: index - (weekdayOfMinDate - 1), to: viewModel.minDate)
        return currentDate!
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var days = Date.daysBetween(fromDate: viewModel.minDate, toDate: viewModel.maxDate)
        let weekdayOfMinDate = Date.weekDay(fromDate: viewModel.minDate)
        days += weekdayOfMinDate - 1
        return days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateReuseIdentifier, for: indexPath) as! CACalendarCollectionViewCell
        
        let weekdayOfMinDate = Date.weekDay(fromDate: viewModel.minDate)
        let currentDate = date(index: indexPath.row)
        let currentMonth = Date.month(fromDate: currentDate)
        let currentDay = Date.day(fromDate: currentDate)
        
        // first few empty cells
        if indexPath.row < weekdayOfMinDate - 1 {
            cell.backgroundColor = Constants.calendarGrayedOutColor
        }
        // normal date cells
        else {
            if currentMonth % 2 != 0 {
                cell.backgroundColor = Constants.calendarEvenMonthColor
            }
            cell.dayLabel?.text = String(currentDay)
            
            if currentDay == 1 {
                cell.monthLabel.text = viewModel.monthTitle[currentMonth]
                cell.monthLabel.isHidden = false
            }
        }
        
        if indexPath == selectedDateIndexPath  {
            cell.didSelected = true
        }
        if viewModel.hasEvent(date: currentDate) {
            cell.dot.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDateIndexPath = indexPath
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var f = collectionView.bounds.size
        f.width = f.width / 7
        f.height = f.width
        return f
    }
    
    
}

extension CACalendarView {
    struct Constants {
        static let calendarTitleViewHeight: CGFloat = 40
        static let calendarDividerColor = UIColor.hexColor(string:"0xd8dbde")
        static let calendarGrayedOutColor = UIColor.hexColor(string:"0xececec")
        static let calendarEvenMonthColor = UIColor.hexColor(string:"0xeaeaea")
    }
}
