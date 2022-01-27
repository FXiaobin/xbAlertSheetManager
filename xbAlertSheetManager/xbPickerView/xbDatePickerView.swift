//
//  xbDatePickerView.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit

enum xbDatePickerViewType {
    case YMD        // 年月日
    case YMD_HM     // 年月日 时分
    case YMD_HMS    // 年月日 时分秒
    case HM         // 时分
    case HMS        // 时分秒
}

class xbDatePickerView: xbAlertSheetBaseView {

    fileprivate var cancelBtn: UIButton?
    fileprivate var sureBtn: UIButton?
    fileprivate var titleLabel: UILabel?
    
    fileprivate var pickerView: UIPickerView?
    
    fileprivate var pickerType: xbDatePickerViewType = .YMD
    
    typealias XBDatePickerViewBlock = ((xbDatePickerView, String) -> Void)
    
    var didSelectRowBlock: XBDatePickerViewBlock?
    
    var maxDate: Date?
    var minDate: Date?
    ///获取最小日期
    private var minDateCom: DateComponents? {
        if let min = minDate {
            return Calendar.current.dateComponents([.year, .month, .day ],   from: min)
        }
        return nil
    }
    ///获取最大日期
    private var maxDateCom: DateComponents? {
        if let max = maxDate {
            return Calendar.current.dateComponents([.year, .month, .day ],   from: max)
        }
        return nil
    }
    
    
    
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],   from: Date())
    //年份和当年相比前后个相差100年
    private let limitYear: Int  = 100
    
    /** 某年某月对应的动态天数*/
    private var daysArr: [Int] = []
    
    /** 前后两百年*/
    fileprivate var yearsArr: [Int] {
        get{
            let currentYear: Int = currentDateCom.year ?? 2020
            let minYear = currentYear - 100
            let maxYear = currentYear + 100
            
            var years: [Int] = []
            for year in minYear..<maxYear {
                years.append(year)
            }
            return years
        }
    }
    
    /** 12个月*/
    fileprivate var monthsArr: [Int] {
        get {
            var months: [Int] = []
            for i in 1...12 {
                months.append(i)
            }
            return months
        }
    }
    
    //计算指定月天数
    fileprivate func getDays(ofYear: Int, ofMonth: Int) -> [Int] {
        
        let calendar = Calendar.current
         
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = ofMonth
        startComps.year = ofYear
         
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = (ofMonth == 12 ? 1 : (ofMonth + 1))
        endComps.year = (ofMonth == 12 ? (ofYear + 1) : ofYear)
         
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from: endComps)!
         
        var set = Set<Calendar.Component>()
        set.insert(.day)
        
        let diff = calendar.dateComponents(set, from: startDate, to: endDate)
        let days = diff.day ?? 30
        
        var daysArr: [Int] = []
        for i in 1...days {
            daysArr.append(i)
        }

        self.daysArr = daysArr
        
        return daysArr
    }
    
    fileprivate var hoursArr : [Int] {
        get {
            var hours: [Int] = []
            for i in 0...23 {
                hours.append(i)
            }
            return hours
        }
    }

    fileprivate var minutesArr : [Int] {
        get {
            var minutes: [Int] = []
            for i in 0...59 {
                minutes.append(i)
            }
            return minutes
        }
    }
    
    fileprivate var secondsArr : [Int] {
        get {
            var seconds: [Int] = []
            for i in 0...59 {
                seconds.append(i)
            }
            return seconds
        }
    }
    
    var selectedDate: String = "" {
        didSet {
            
            switch pickerType {
            case .YMD:
                let selTitles = selectedDate.split(separator: "-")
                if selTitles.count > 2 {
                    let year: Int = Int(selTitles.first!) ?? (currentDateCom.year ?? 2020)
                    let month: Int = Int(selTitles[1]) ?? 1
                    let day: Int = Int(selTitles.last!) ?? 1
                    
                    daysArr = getDays(ofYear: year, ofMonth: month)
                    
                    let yearInt = yearsArr.firstIndex(of: year) ?? 0
                    let monthInt = monthsArr.firstIndex(of: month) ?? 0
                    // 如果没有这一天就滚动到对应月份的最后一天
                    let dayInt = daysArr.firstIndex(of: day) ?? (daysArr.count - 1)
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(yearInt, inComponent: 0, animated: true)
                    pickerView?.selectRow(monthInt, inComponent: 1, animated: true)
                    pickerView?.selectRow(dayInt, inComponent: 2, animated: true)
                }
              
                break
                
            case .YMD_HM:
                let ymd: String = String(selectedDate.split(separator: " ").first ?? "")
                let hm: String = String(selectedDate.split(separator: " ").last ?? "")
                
                let selYMDTitles = ymd.split(separator: "-")
                if selYMDTitles.count > 2 {
                    let year: Int = Int(selYMDTitles.first!) ?? (currentDateCom.year ?? 2020)
                    let month: Int = Int(selYMDTitles[1]) ?? 1
                    let day: Int = Int(selYMDTitles.last!) ?? 1
                    
                    daysArr = getDays(ofYear: year, ofMonth: month)
                    
                    let yearInt = yearsArr.firstIndex(of: year) ?? 0
                    let monthInt = monthsArr.firstIndex(of: month) ?? 0
                    // 如果没有这一天就滚动到对应月份的最后一天
                    let dayInt = daysArr.firstIndex(of: day) ?? 0
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(yearInt, inComponent: 0, animated: true)
                    pickerView?.selectRow(monthInt, inComponent: 1, animated: true)
                    pickerView?.selectRow(dayInt, inComponent: 2, animated: true)
                }
                
                let hmTitles = hm.split(separator: ":")
                if hmTitles.count > 1 {
                    let hour: Int = Int(hmTitles.first!) ?? 0
                    let minute: Int = Int(hmTitles.last!) ?? 0
                    let hourInt = hoursArr.firstIndex(of: hour) ?? 0
                    let minuteInt = minutesArr.firstIndex(of: minute) ?? 0
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(hourInt, inComponent: 3, animated: true)
                    pickerView?.selectRow(minuteInt, inComponent: 4, animated: true)
                }
                
                break
                
            case .YMD_HMS:
                let ymd: String = String(selectedDate.split(separator: " ").first ?? "")
                let hms: String = String(selectedDate.split(separator: " ").last ?? "")
                
                let selYMDTitles = ymd.split(separator: "-")
                if selYMDTitles.count > 2 {
                    let year: Int = Int(selYMDTitles.first!) ?? (currentDateCom.year ?? 2020)
                    let month: Int = Int(selYMDTitles[1]) ?? 1
                    let day: Int = Int(selYMDTitles.last!) ?? 1
                    
                    daysArr = getDays(ofYear: year, ofMonth: month)
                    
                    let yearInt = yearsArr.firstIndex(of: year) ?? 0
                    let monthInt = monthsArr.firstIndex(of: month) ?? 0
                    // 如果没有这一天就滚动到对应月份的最后一天
                    let dayInt = daysArr.firstIndex(of: day) ?? 0
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(yearInt, inComponent: 0, animated: true)
                    pickerView?.selectRow(monthInt, inComponent: 1, animated: true)
                    pickerView?.selectRow(dayInt, inComponent: 2, animated: true)
                }
                
                let hmsTitles = hms.split(separator: ":")
                if hmsTitles.count > 2 {
                    let hour: Int = Int(hmsTitles.first!) ?? 0
                    let minute: Int = Int(hmsTitles[1]) ?? 0
                    let second: Int = Int(hmsTitles.last!) ?? 0
                    
                    let hourInt = hoursArr.firstIndex(of: hour) ?? 0
                    let minuteInt = minutesArr.firstIndex(of: minute) ?? 0
                    let secondInt = secondsArr.firstIndex(of: second) ?? 0
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(hourInt, inComponent: 3, animated: true)
                    pickerView?.selectRow(minuteInt, inComponent: 4, animated: true)
                    pickerView?.selectRow(secondInt, inComponent: 5, animated: true)
                }
              
                break
                
            case .HMS:
                let hmsTitles = selectedDate.split(separator: ":")
                if hmsTitles.count > 2 {
                    let hour: Int = Int(hmsTitles.first!) ?? 0
                    let minute: Int = Int(hmsTitles[1]) ?? 0
                    let second: Int = Int(hmsTitles.last!) ?? 0
                    
                    let hourInt = hoursArr.firstIndex(of: hour) ?? 0
                    let minuteInt = minutesArr.firstIndex(of: minute) ?? 0
                    let secondInt = secondsArr.firstIndex(of: second) ?? 0
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(hourInt, inComponent: 0, animated: true)
                    pickerView?.selectRow(minuteInt, inComponent: 1, animated: true)
                    pickerView?.selectRow(secondInt, inComponent: 2, animated: true)
                }
              
                break
                
            case .HM:
                let hmsTitles = selectedDate.split(separator: ":")
                if hmsTitles.count > 1 {
                    let hour: Int = Int(hmsTitles.first!) ?? 0
                    let minute: Int = Int(hmsTitles[1]) ?? 0
                    
                    let hourInt = hoursArr.firstIndex(of: hour) ?? 0
                    let minuteInt = minutesArr.firstIndex(of: minute) ?? 0
                    
                    pickerView?.reloadAllComponents()
                    pickerView?.selectRow(hourInt, inComponent: 0, animated: true)
                    pickerView?.selectRow(minuteInt, inComponent: 1, animated: true)
                }
              
                break
            
            }
            
        }
    }
    
    fileprivate func getSelectedTitle() -> String {

        var selTitle = ""
        
        switch pickerType {
        case .YMD, .YMD_HM, .YMD_HMS:
            // 最大日期和最小日期限制的更新
            maxMinDateUpdate(animated: false)
            
        default:
            break
        }
        
        switch pickerType {
        case .YMD:
            var year: Int = self.currentDateCom.year ?? 2020
            var month: Int = self.currentDateCom.month ?? 1
            var day: Int = self.currentDateCom.day ?? 1
            
            // 当前选中的年月
            let selYear = pickerView?.selectedRow(inComponent: 0) ?? 100
            let selMonth = pickerView?.selectedRow(inComponent: 1) ?? 0
            let selDay = pickerView?.selectedRow(inComponent: 2) ?? 0

            year = self.yearsArr[selYear]
            month = self.monthsArr[selMonth]
            day = self.daysArr[selDay]
            
            selTitle = String(format: "%04d-%02d-%02d", year, month, day)
            selectedDate = selTitle
            debugPrint("--- selTitle = \(selTitle)")
            
            return selTitle
            
        case .YMD_HM:
            
            var year: Int = self.currentDateCom.year ?? 2020
            var month: Int = self.currentDateCom.month ?? 1
            var day: Int = self.currentDateCom.day ?? 1
            var hour: Int = self.currentDateCom.hour ?? 0
            var minute: Int = self.currentDateCom.minute ?? 0

            // 当前选中的年月
            let selYear = pickerView?.selectedRow(inComponent: 0) ?? 100
            let selMonth = pickerView?.selectedRow(inComponent: 1) ?? 0
            let selDay = pickerView?.selectedRow(inComponent: 2) ?? 0
            let selHour = pickerView?.selectedRow(inComponent: 3) ?? 0
            let selMinute = pickerView?.selectedRow(inComponent: 4) ?? 0

            year = self.yearsArr[selYear]
            month = self.monthsArr[selMonth]
            day = self.daysArr[selDay]
            hour = self.hoursArr[selHour]
            minute = self.minutesArr[selMinute]
            
            selTitle = String(format: "%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
            selectedDate = selTitle
            debugPrint("--- selTitle = \(selTitle)")
            
            return selTitle
            
        case .YMD_HMS:
            
            var year: Int = self.currentDateCom.year ?? 2020
            var month: Int = self.currentDateCom.month ?? 1
            var day: Int = self.currentDateCom.day ?? 1
            var hour: Int = self.currentDateCom.hour ?? 0
            var minute: Int = self.currentDateCom.minute ?? 0
            var second: Int = self.currentDateCom.second ?? 0

            // 当前选中的年月
            let selYear = pickerView?.selectedRow(inComponent: 0) ?? 100
            let selMonth = pickerView?.selectedRow(inComponent: 1) ?? 0
            let selDay = pickerView?.selectedRow(inComponent: 2) ?? 0
            let selHour = pickerView?.selectedRow(inComponent: 3) ?? 0
            let selMinute = pickerView?.selectedRow(inComponent: 4) ?? 0
            let selSecond = pickerView?.selectedRow(inComponent: 5) ?? 0

            year = self.yearsArr[selYear]
            month = self.monthsArr[selMonth]
            day = self.daysArr[selDay]
            hour = self.hoursArr[selHour]
            minute = self.minutesArr[selMinute]
            second = self.secondsArr[selSecond]
            
            selTitle = String(format: "%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
            selectedDate = selTitle
            debugPrint("--- selTitle = \(selTitle)")
            
            return selTitle
            
        case .HMS:
            var hour: Int = self.currentDateCom.hour ?? 0
            var minute: Int = self.currentDateCom.minute ?? 0
            var second: Int = self.currentDateCom.second ?? 0
            // 当前选中的
            let selHour = pickerView?.selectedRow(inComponent: 0) ?? 0
            let selMinute = pickerView?.selectedRow(inComponent: 1) ?? 0
            let selSecond = pickerView?.selectedRow(inComponent: 2) ?? 0

            hour = self.hoursArr[selHour]
            minute = self.minutesArr[selMinute]
            second = self.secondsArr[selSecond]
            
            selTitle = String(format: "%02d:%02d:%02d", hour, minute, second)
            selectedDate = selTitle
            debugPrint("--- selTitle = \(selTitle)")
            
            return selTitle
            
        case .HM:
            var hour: Int = self.currentDateCom.hour ?? 0
            var minute: Int = self.currentDateCom.minute ?? 0
            // 当前选中的
            let selHour = pickerView?.selectedRow(inComponent: 0) ?? 0
            let selMinute = pickerView?.selectedRow(inComponent: 1) ?? 0

            hour = self.hoursArr[selHour]
            minute = self.minutesArr[selMinute]
            
            selTitle = String(format: "%02d:%02d", hour, minute)
            selectedDate = selTitle
            debugPrint("--- selTitle = \(selTitle)")
            
            return selTitle
        }
    }
    
    convenience init(frame: CGRect, defaultVaule: String = "", type: xbDatePickerViewType, completed: XBDatePickerViewBlock?){
        self.init(frame: frame)
        
        setupUI(defaultVaule: defaultVaule, type: type, completed: completed)
    
    }
    
    @objc func pickerViewBtnAction(sender: UIButton) {
        
        self.xb_dismiss()
        
        let index = sender.tag - 200
        if index > 0 {
            // 确定
            let selTitle = getSelectedTitle()
            if let block = self.didSelectRowBlock {
                block(self, selTitle)
            }
        }
    }
  
   
    fileprivate func setupUI(defaultVaule: String = "", type: xbDatePickerViewType, completed: XBDatePickerViewBlock?) {
        self.didSelectRowBlock = completed
        pickerType = type
        
        self.backgroundColor = UIColor.white
        
        // 圆角
        // xb_alertSheetBaseCornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 16.0)
        
        self.cancelBtn = UIButton()
        self.cancelBtn?.setTitle("取消", for: .normal)
        self.cancelBtn?.setTitleColor(UIColor.blue, for: .normal)
        self.cancelBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.cancelBtn?.addTarget(self, action: #selector(pickerViewBtnAction(sender:)), for: .touchUpInside)
        self.cancelBtn?.tag = 200
        self.addSubview(self.cancelBtn!)
        
        
        self.sureBtn = UIButton()
        self.sureBtn?.setTitle("确定", for: .normal)
        self.sureBtn?.setTitleColor(UIColor.blue, for: .normal)
        self.sureBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.sureBtn?.addTarget(self, action: #selector(pickerViewBtnAction(sender:)), for: .touchUpInside)
        self.sureBtn?.tag = 201
        self.addSubview(self.sureBtn!)

        self.titleLabel = UILabel()
        self.titleLabel?.text = "请选择"
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(self.titleLabel!)


        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 44.0, width: self.bounds.size.width, height: self.bounds.size.height - 44.0))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.addSubview(self.pickerView!)
        
        //
        let dateFormmater = DateFormatter()
        switch type {
        case .YMD:
            dateFormmater.dateFormat = "yyyy-MM-dd"
        case .YMD_HM:
            dateFormmater.dateFormat = "yyyy-MM-dd HH:mm"
        case .YMD_HMS:
            dateFormmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case .HMS:
            dateFormmater.dateFormat = "HH:mm:ss"
        case .HM:
            dateFormmater.dateFormat = "HH:mm"
       
        }
        
        pickerView?.reloadAllComponents()
        let todayStr = dateFormmater.string(from: Date())
        selectedDate = defaultVaule.count == 0 ? todayStr : defaultVaule
        
        self.cancelBtn?.snp.makeConstraints({ make in
            make.left.top.equalTo(self)
            make.size.equalTo(CGSize(width: 60.0, height: 44.0))
        })
        
        self.sureBtn?.snp.makeConstraints({ make in
            make.top.equalTo(self)
            make.right.equalTo(self.snp_right)
            make.size.equalTo(CGSize(width: 60.0, height: 44.0))
        })

        self.titleLabel?.snp_makeConstraints({ make  in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.cancelBtn!)
        })

        self.pickerView?.snp_makeConstraints({ make  in
            make.left.equalTo(self)
            make.top.equalTo(self.cancelBtn!.snp_bottom)
            make.right.equalTo(self.snp_right)
            make.bottom.equalTo(self.snp_bottom)
        })
    }

}

extension xbDatePickerView: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerType {
        case .YMD, .HMS:
            return 3
        case .YMD_HM:
            return 5
        case .YMD_HMS:
            return 6
        case .HM:
            return 2
        }
    }
    
    /** 根据当前选中的年月来刷新对应的天数*/
    func updateDaysArr() -> [Int] {
        let selYear = pickerView!.selectedRow(inComponent: 0)
        let selMonth = pickerView!.selectedRow(inComponent: 1)
        let year = yearsArr[selYear]
        let month = monthsArr[selMonth]
       
        daysArr = getDays(ofYear: year, ofMonth: month)
//        pickerView!.reloadComponent(2)
        return daysArr
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerType {

        case .YMD, .YMD_HMS, .YMD_HM:
            if component == 0 {
                return yearsArr.count
            }else if component == 1 {
                return monthsArr.count
            }else if component == 2 {
//                return daysArr.count
                let days = updateDaysArr()
                return days.count
                
            }else if component == 3 {
                return hoursArr.count
            }else if component == 4 {
                return minutesArr.count
            }else if component == 5 {
                return secondsArr.count
            }
            return 0
            
        case .HM, .HMS:
            if component == 0 {
                return hoursArr.count
            }else if component == 1 {
                return minutesArr.count
            }else if component == 2 {
                return secondsArr.count
            }
            return 0
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        /*
        //设置分割线的颜色
        for item in pickerView.subviews {
            item.backgroundColor = UIColor.clear
            if item.frame.size.height <= 1.0 {
                item.backgroundColor = UIColor.gray
            }
        }
         */
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        switch pickerType {

        case .YMD, .YMD_HMS, .YMD_HM:
            if component == 0 {
                let title = String(format: "%04d年", yearsArr[row])
                titleLabel.text = title
                
            }else if component == 1 {
                let title =  String(format: "%02d月", monthsArr[row])
                titleLabel.text = title
                
            }else if component == 2 {
                let title =  String(format: "%02d日", daysArr[row])
                titleLabel.text = title
            }else if component == 3 {
                let title =  String(format: "%02d时", hoursArr[row])
                titleLabel.text = title
            }else if component == 4 {
                let title =  String(format: "%02d分", minutesArr[row])
                titleLabel.text = title
            }else if component == 5 {
                let title =  String(format: "%02d秒", secondsArr[row])
                titleLabel.text = title
            }
            return titleLabel
            
        case .HM, .HMS:
            if component == 0 {
                let title =  String(format: "%02d时", hoursArr[row])
                titleLabel.text = title
            }else if component == 1 {
                let title =  String(format: "%02d分", minutesArr[row])
                titleLabel.text = title
            }else if component == 2 {
                let title =  String(format: "%02d秒", secondsArr[row])
                titleLabel.text = title
            }
            return titleLabel
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerType {
        case .YMD, .YMD_HMS, .YMD_HM:
            if component == 0 || component == 1 {
                pickerView.reloadComponent(2)
            }
            
            // 必须做延迟 不然立即selectedRow获取day会崩溃
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // 先更新 再获取最终选中的值
                self.maxMinDateUpdate(animated: true)
                //_ = self.getSelectedTitle()
            }
            
            break
            
        default:
            break
        }
        
    }
    
    
    func maxMinDateUpdate(animated: Bool) {
        let selYear = pickerView!.selectedRow(inComponent: 0)
        let selMonth = pickerView!.selectedRow(inComponent: 1)
        let selDay = pickerView!.selectedRow(inComponent: 2)
        let year = yearsArr[selYear]
        let month = monthsArr[selMonth]
        let day = daysArr[selDay]
        
        let dateString = String(format: "%04ld-%02ld-%02ld", year, month, day)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let chooseDate = dateFormatter.date(from: dateString) ?? Date()
        
        let startYear: Int = yearsArr.first!
        if let maxCom = self.maxDateCom {
            
            // 大于最大时间 就自动滚回到(选中)最大时间
            if chooseDate.compare(maxDate!) == .orderedDescending {
                let sYear = maxCom.year! - startYear
                let sMonth = maxCom.month!
                // 选中最大时间
                pickerView!.selectRow(sYear, inComponent: 0, animated: animated)
                pickerView!.selectRow(sMonth - 1, inComponent: 1, animated: animated)
                // 要写在这里 刷新第三列的数据 防止数据错乱
                pickerView!.reloadComponent(2)
                pickerView!.selectRow((maxCom.day!) - 1, inComponent: 2, animated: animated)
                
                selectedDate = dateFormatter.string(from: maxDate!)
            }
        }
        
        if let minCom = self.minDateCom {
            // 小于最小时间 就自动滚回到(选中)最小时间*/
            if chooseDate.compare(minDate!) == .orderedAscending {
                let sYear = minCom.year! - startYear
                let sMonth = minCom.month!
                // 选中最小时间
                pickerView!.selectRow(sYear, inComponent: 0, animated: true)
                pickerView!.selectRow(sMonth - 1, inComponent: 1, animated: true)
                // 要写在这里 刷新第三列的数据 防止数据错乱
                pickerView!.reloadComponent(2)
                pickerView!.selectRow((minCom.day!) - 1 , inComponent: 2, animated: true)
                
                selectedDate = dateFormatter.string(from: minDate!)
            }
        }
    }
    
    
    
}

