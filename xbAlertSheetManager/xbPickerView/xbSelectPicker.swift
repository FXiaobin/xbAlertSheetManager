//
//  xbSelectPicker.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit

class xbSelectPicker: xbAlertSheetBaseView {

    fileprivate var cancelBtn: UIButton?
    fileprivate var sureBtn: UIButton?
    fileprivate var titleLabel: UILabel?
    
    fileprivate var pickerView: UIPickerView?
    
    typealias XBSelectedPickerViewBlock = ((xbSelectPicker, [String], [Int]) -> Void)
    
    fileprivate var didSelectRowBlock: XBSelectedPickerViewBlock?
    
    fileprivate var dataArr: [[String]] = [[]] {
        didSet{
            self.pickerView?.reloadAllComponents()
        }
    }
    
    public var selectedTitles: [String] = [] {
        didSet {
            for (i, item) in selectedTitles.enumerated() {
                let subArr = dataArr[i]
                for (j,subItem) in subArr.enumerated() {
                    if item == subItem {
                        self.pickerView?.selectRow(j, inComponent: i, animated: true)
                    }
                }
            }
        }
    }
    
    fileprivate var selectedRows: [Int] {
        get{
            var rows: [Int] = []
           
            for (i, item) in selectedTitles.enumerated() {
                let subArr = dataArr[i]
                for (j,subItem) in subArr.enumerated() {
                    if item == subItem {
                        rows.append(j)
                        self.pickerView?.selectRow(j, inComponent: i, animated: true)
                    }
                }
            }
            return rows
        }
    }
    
    public convenience init(frame: CGRect, pickeList:[[String]] = [[]], defaultVaule: [String] = [], completed: XBSelectedPickerViewBlock?){
        self.init(frame: frame)
        
        setupUI(pickeList: pickeList, defaultVaule: defaultVaule, completed: completed)
    }
   
    public func setupUI(pickeList:[[String]] = [[]], defaultVaule: [String] = [], completed: XBSelectedPickerViewBlock?) {
        self.didSelectRowBlock = completed
        
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
        
        self.dataArr = pickeList
        self.selectedTitles = defaultVaule
        
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

    
    @objc fileprivate func pickerViewBtnAction(sender: UIButton) {
        
        self.xb_dismiss()
        
        let index = sender.tag - 200
        if index > 0 {
            // 确定
            if let block = self.didSelectRowBlock {
                block(self, selectedTitles, selectedRows)
            }
        }
    }
  
}

extension xbSelectPicker: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let subArr = dataArr[component]
        return subArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let subArr = dataArr[component]
        return subArr[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
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
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        let subArr = dataArr[component]
        let title = subArr[row]
        titleLabel.text = title
           
        return titleLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        for (i,subArr) in dataArr.enumerated() {
            if i == component {
                let title = subArr[row]
                selectedTitles[i] = title
            }
        }
    
        //        print("titles = \(selectedTitles), rows = \(selectedRows)")
    }
    
    
    
    
    
    
}

