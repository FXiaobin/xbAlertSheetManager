//
//  ViewController.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit

class ViewController: UIViewController {

    var defTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.yellow
        
        let btn  = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 200))
        btn.backgroundColor = UIColor.orange
        btn.addTarget(self, action: #selector(btnAction ), for: .touchUpInside)
        self.view.addSubview(btn)
        
       
        
        
    }

    @objc func btnAction() {
        
        
//        let vc = xbBaseAlertController()
//        vc.xb_showAlertController()
        
//        let vc = xbBaseSheetController()
//        vc.xb_showSheetController(showType: .fromRight)
//
        
//        let vc = xbBaseSheetListController()
//        vc.xb_showSheetListController()
        
        
//        let vc = ChooseStartEndDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300))
//        vc.defaultTitle = defTitle
//        vc.xb_alertSheetBaseCornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 10.0)
//
//        vc.xb_show(nil, type: .fromBottom, completed: nil)
//
//        vc.pickerViewBtnActionBlock = { (picker, tag, year , month, day, title) in
//
//            self.defTitle = year + "," + month + "," + day
//
//            debugPrint("index = \(tag), year = \(year), monMid = \(month), monRig = \(day), title = \(title)")
//        }
        
        
//        let picker = xbSingleSelectPicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300), pickeList: ["男","女", "保密"], defaultVaule: "女") { picker , title , index in
//            debugPrint("title = \(title), index = \(index)")
//
//        }
//
//        picker.xb_showSheet()
        
        
//        let picker = xbDatePickerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300), defaultVaule: "", type: .HMS) { picker , title  in
//
//            debugPrint("title = \(title)")
//        }
//        picker.xb_showSheet()
        
//        let picker = xbSelectPicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300), pickeList: [["男","女", "保密"],["11","22", "33"]], defaultVaule: ["保密","22"]) { picker , titles, indexs  in
//            debugPrint("titles = \(titles), indexs = \(indexs)")
//        }
//        picker.xb_showSheet()
        
        
        
        let picker = xbStartEndDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300), defaultVaule: "2026,02,09") { picker , tag , year , monMid , monRight , title  in
            debugPrint("title = \(title), tag = \(tag)")
        }
        picker.xb_showSheet()
    }

}

