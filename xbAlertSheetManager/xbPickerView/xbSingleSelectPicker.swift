//
//  xbSingleSelectPicker.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit
import SnapKit

class xbSingleSelectPicker: xbAlertSheetBaseView {

    var cancelBtn: UIButton?
    var sureBtn: UIButton?
    var titleLabel: UILabel?
    
    fileprivate var pickerView: UIPickerView?
    
    fileprivate var didSelectRowBlock: ((xbSingleSelectPicker,String,Int) -> ())?
    
    fileprivate var dataArr: [Any] = [] {
        didSet{
            self.pickerView?.reloadAllComponents()
            if self.dataArr.count > self.selectedRow {
                self.xb_selectedTitle = self.dataArr[self.selectedRow] as! String
                self.pickerView?.selectRow(self.selectedRow, inComponent: 0, animated: true)
            }
        }
    }
    
    public var xb_selectedTitle: String = "" {
        didSet {
            for (i,item) in dataArr.enumerated() {
                if item as! String == xb_selectedTitle {
                    selectedRow = i
                }
            }
        }
    }
    
    
    fileprivate var selectedRow: Int {
        set{
            if dataArr.count > newValue {
                self.pickerView?.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        }
        
        get{
            var selRow = 0
            for (i,item) in dataArr.enumerated() {
                if item as? String == xb_selectedTitle {
                    selRow = i
                    break
                }
            }
            return selRow
        }
    }
    
    public convenience init(frame: CGRect, pickeList:[Any] = [], defaultVaule: String = "", completed: ((xbSingleSelectPicker,String,Int) -> ())?) {
        self.init(frame: frame)
        
        setupUI(pickeList: pickeList, defaultVaule: defaultVaule, completed: completed)
    
    }
   
    public  func setupUI(pickeList:[Any] = [], defaultVaule: String = "", completed: ((xbSingleSelectPicker,String,Int) -> ())?) {
        self.didSelectRowBlock = completed
        
        self.backgroundColor = UIColor.white
        
        // 圆角
        // xb_cornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 16.0)
        
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
        // 默认选中第一个
        self.pickerView?.reloadAllComponents()
        self.pickerView?.selectRow(self.selectedRow, inComponent: 0, animated: true)
        
        self.dataArr = pickeList
        self.xb_selectedTitle = defaultVaule
        
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

    
    @objc func pickerViewBtnAction(sender: UIButton) {
        
        self.xb_dismiss()
        
        let index = sender.tag - 200
        if index > 0 {
            // 确定
            if let block = self.didSelectRowBlock {
                block(self, xb_selectedTitle , selectedRow)
            }
        }
    }
  
}

extension xbSingleSelectPicker: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataArr[row] as? String
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44.0
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
        
        let title = self.dataArr[row] as? String
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        return titleLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = self.dataArr[row] as! String
        self.xb_selectedTitle = title
        
    }
    
    
    
    
    
    
}
