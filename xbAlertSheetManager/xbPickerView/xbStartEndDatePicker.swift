//
//  xbStartEndDatePicker.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit
import SnapKit

class xbStartEndDatePicker: xbAlertSheetBaseView {

    var cancelBtn: UIButton?
    var sureBtn: UIButton?
    var titleLabel: UILabel?
    
    private var myPickerView: UIPickerView?
   
    /**按钮tag 年份 中间月份 右边月份 title*/
    typealias xbStartEndDatePickerBlock = ((xbStartEndDatePicker,Int,String,String,String,String) -> ())
    private var pickerViewBtnActionBlock: xbStartEndDatePickerBlock?
    
    
    private var selectedYear: String = "1922"
    private var selectedMonthMid: String = "01"
    private var selectedMonthRight: String = "01"
    
    
    private var dataArr: [Any] = []
    
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],   from: Date())
    //年份和当年相比前后个相差100年
    private let limitYear: Int  = 100
    
    /** 选中的年月*/
    private var selectedTitle: String = ""
    
    /** 外部设置默认选中的年月， 用逗号分割, 1922年05月至06月 1922,05,06*/
    public var defaultTitle: String? {
        didSet{
            guard let title = defaultTitle else { return }
            
            let array = title.split(separator: ",")
            if array.count > 2 {
                let year: String = String(array.first ?? "1922")
                let monthMid: String = String(array[1])
                let monthRight: String = String(array.last ?? "1")
                
                let yearArr: [String] = dataArr.first as! [String]
                let monthMidArr: [String] = dataArr[1] as! [String]
                let monthRightArr: [String] = dataArr.last as! [String]
                
                let yearRow: Int = yearArr.firstIndex(of: year) ?? 0
                let monthMidRow: Int = monthMidArr.firstIndex(of: monthMid) ?? 0
                let monthRightRow: Int = monthRightArr.firstIndex(of: monthRight) ?? 0
                
                myPickerView?.selectRow(yearRow, inComponent: 0, animated: true)
                myPickerView?.selectRow(monthMidRow, inComponent: 1, animated: true)
                myPickerView?.selectRow(monthRightRow, inComponent: 3, animated: true)
                
                
                didSeletedPickerView(pickerView: myPickerView!)
            }
        }
    }
    
    /** defaultVaule 默认选中的年月， 用逗号分割, 1922年05月至06月 1922,05,06*/
    public convenience init(frame: CGRect, defaultVaule: String = "", completed: xbStartEndDatePickerBlock?) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.pickerViewBtnActionBlock = completed
        
        // 年份
        
        let currentYear: Int = currentDateCom.year ?? 2020
        let minYear = currentYear - 100
        let maxYear = currentYear + 100
        
        var yearArr: [String] = []
        for year in minYear..<maxYear {
            yearArr.append(String(year))
        }
    
        
        // 月份
        var montArr: [String] = []
        for i  in 1...12 {
            montArr.append(String(format: "%02d", i))
        }
        
        let zhiArr = ["至"]
        
        self.dataArr.append(yearArr)
        self.dataArr.append(montArr)
        self.dataArr.append(zhiArr)
        self.dataArr.append(montArr)
        
        
        self.setupUI(withDefaultValue: defaultVaule)
        
        
    }

    public func setupUI(withDefaultValue: String) {
        
        // 圆角
//        xb_alertSheetBaseCornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 10.0)
        
        self.cancelBtn = UIButton()
        self.cancelBtn?.setTitle("取消", for: .normal)
        self.cancelBtn?.setTitleColor(UIColor.gray, for: .normal)
        self.cancelBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.cancelBtn?.addTarget(self, action: #selector(pickerViewBtnAction(sender:)), for: .touchUpInside)
        self.cancelBtn?.tag = 200
        self.addSubview(self.cancelBtn!)
        
        
        self.sureBtn = UIButton()
        self.sureBtn?.setTitle("完成", for: .normal)
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

        self.myPickerView = UIPickerView(frame: CGRect(x: 0, y: 44.0, width: self.bounds.size.width, height: self.bounds.size.height - 44.0))
        self.myPickerView?.delegate = self
        self.myPickerView?.dataSource = self
        self.addSubview(self.myPickerView!)
        
        
        defaultTitle = withDefaultValue
        
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

        self.myPickerView?.snp_makeConstraints({ make  in
            make.left.equalTo(self)
            make.top.equalTo(self.cancelBtn!.snp_bottom)
            make.right.equalTo(self.snp_right)
            make.bottom.equalTo(self.snp_bottom)
        })
    }

    
    @objc func pickerViewBtnAction(sender: UIButton) {
        let index = sender.tag - 200
        
        xb_dismiss()

        if self.pickerViewBtnActionBlock != nil {
            didSeletedPickerView(pickerView: myPickerView!)
            
            self.pickerViewBtnActionBlock?(self, index, selectedYear, selectedMonthMid, selectedMonthRight, selectedTitle)
        }
    }
    
    func didSeletedPickerView(pickerView: UIPickerView) {
        
        let yearRow = pickerView.selectedRow(inComponent: 0)
        let yearArr = self.dataArr[0] as! [String]
        let year = yearArr[yearRow]
        
        let monthMidRow = pickerView.selectedRow(inComponent: 1)
        let monthMidArr = self.dataArr[1] as! [String]
        let monthMid = monthMidArr[monthMidRow]
        
        let monthRightRow = pickerView.selectedRow(inComponent: 3)
        let monthRightArr = self.dataArr[3] as! [String]
        var monthRight = monthRightArr[monthRightRow]
        
        let mMid: Int = Int(monthMid) ?? 1
        var mRight: Int = Int(monthRight) ?? 1
        
        // 后面月份不能小于前面的月份
        if mRight < mMid {
            mRight = mMid
            monthRight = String(mMid)
            pickerView.selectRow(monthMidRow, inComponent: 3, animated: true)
        }
        
        selectedYear = String(format: "%02d", (Int(year) ?? 1922))
        selectedMonthMid = String(format: "%02d", mMid)
        selectedMonthRight = String(format: "%02d", mRight)
        
        let title = year + "年" + monthMid + "月" + "至" + monthRight + "月"
        self.selectedTitle = title
//        print("selectedStr = \(String(describing: title))")
        
    }
    
}


extension xbStartEndDatePicker: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 1
        }
        
        let arr = self.dataArr[component]
        return (arr as AnyObject).count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arr = self.dataArr[component] as! [String]
        var title = arr[row]
        if component == 0 {
            title += "年"
        }else if component == 1 || component == 3{
            title += "月"
        }
        return title
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44.0
    }
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        if component == 0 {
//            return UIScreen.main.bounds.size.width / 3.0
//        }
//        return (UIScreen.main.bounds.size.width / 3.0 * 2) / 3.0
//    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        /*
        //设置分割线的颜色
        for item in pickerView.subviews {
            item.backgroundColor = UIColor.clear
            if item.frame.size.height <= 1.0 {
                item.backgroundColor = UIColor.gray
            }
        }
        */
           
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        let titleLabel = UILabel()
        titleLabel.textColor = (component == 2) ? UIColor.gray : UIColor.black
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        return titleLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        didSeletedPickerView(pickerView: myPickerView!)
        
    }
  
}



