//
//  xbBaseSheetListController.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit

private let kSheetListTop_H         : CGFloat = 44.0
private let kSheetListButton_W      : CGFloat = 50.0
private let kWidth = UIScreen.main.bounds.size.width
private let kHeight = UIScreen.main.bounds.size.height

private let kSafeBottomH: CGFloat = ((UIApplication.shared.statusBarFrame.size.height > 20.0) ? 34.0 : 0.0)
private let kNavH: CGFloat = ((UIApplication.shared.statusBarFrame.size.height > 20.0) ? 88.0 : 64.0)

public class xbBaseSheetListController: xbBaseSheetController {

    public typealias xbBaseSheetListBlock = ((xbBaseSheetListController, Int) -> Void)
    
    fileprivate var didSelectRowAtBlock: xbBaseSheetListBlock?
    fileprivate var btnActionBlock: xbBaseSheetListBlock?
    
    public var showCancelBtn = false
    public var rowHeight: CGFloat = 50.0
    
    var dataArr: [Any] = []
    
    public convenience init(withTitle: String?, didSelectedIndex: xbBaseSheetListBlock?, btnAction: xbBaseSheetListBlock?) {
        self.init()
        self.titleLabel.text = withTitle
        self.didSelectRowAtBlock = didSelectedIndex
        self.btnActionBlock = btnAction
    }
    
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        
    }
    
    @objc fileprivate func sheetListBtnAction(sender: UIButton) {
        let index = sender.tag - 1000
        self.xb_dismiss()
        
        if let block = self.btnActionBlock {
            block(self,index)
        }
        
        if index == 0 {     // 取消
            
        }else if (index == 1) {     // 关闭
            
        }
        
    }
    
    public override func xb_customMyContentView() {
        // super.customMyContentView()
        
        // 1. 初始化自定义视图
        let contentView = UIView(frame: CGRect(x: 0, y: kHeight, width: kWidth, height: 100))
        contentView.backgroundColor = UIColor.white
//        self.view.addSubview(contentView)
        
        // 2. 全局引用
        self.xb_contentView = contentView
        
        // 3. 设置圆角 并添加到self.view上
        if let customView = self.xb_contentView {
            self.view.addSubview(customView)
            if self.xb_showCornerRad {
                self.xb_sheetCornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 10.0)
            }
            
        }else{
            debugPrint("自定义视图不存在，无法弹出视图")
        }
        
        setupUI()
    }
    
    // 模拟网络请求 子类需重写来获取数据更新列表高度
    public func xb_loadListData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for _  in 0..<10 {
                self.dataArr.append("")
            }
            
            self.tableView.reloadData()
            
            self.xb_updateContentViewRect()
        }
    }
    
    /** 更新contentView的frame*/
    public func xb_updateContentViewRect() {
        
        guard var frame = self.xb_contentView?.frame else {
            return
        }
   
        var height: CGFloat = kSheetListTop_H + kSafeBottomH
        if showCancelBtn {
            height += (50.0 + 10.0)
        }
        height += rowHeight * CGFloat(self.dataArr.count)
        if height > (kHeight - kSafeBottomH - kNavH) {
            height = (kHeight - kSafeBottomH - kNavH)
        }
        frame.size.height = height
        frame.origin.y = kHeight - height
        
        UIView.animate(withDuration: 0.25) {
            self.xb_contentView?.frame = frame
            
            // frame发生了变化 所以圆角要重新设置
            if self.xb_showCornerRad {
                self.xb_updateSheetCorners()
            }

        } completion: { finished  in
        
        }
    }
    
    // 子类可重写来更新圆角设置
    public func xb_updateSheetCorners() {
        self.xb_sheetCornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 10.0)
    }
    
    public func xb_showSheetListController() {
        super.xb_showSheetController(showType: .fromBottom)
        
        xb_loadListData()
    }
    
    public func setupUI(){
        self.xb_contentView?.addSubview(self.topView)
        self.topView.addSubview(self.titleLabel)
        self.topView.addSubview(self.closeBtn)
        
        self.xb_contentView?.addSubview(self.cancelBtn)
        self.xb_contentView?.addSubview(self.tableView)
        
        self.cancelBtn.isHidden = !showCancelBtn
       
        self.topView.snp_makeConstraints { make  in
            make.left.right.equalToSuperview()
            make.height.equalTo(kSheetListTop_H)
            make.top.equalToSuperview()
        }
        
        self.cancelBtn.snp_makeConstraints { make  in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomH)
            
            if showCancelBtn{
                make.height.equalTo(50.0)
            }else{
                make.height.equalTo(0.0)
            }
        }
        
        self.tableView.snp_makeConstraints { make  in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topView.snp_bottom)
            if showCancelBtn{
                make.bottom.equalTo(self.cancelBtn.snp_top).offset(-10.0)
            }else{
                make.bottom.equalTo(self.cancelBtn.snp_top).offset(0.0)
            }
            
        }
        
        self.titleLabel.snp_makeConstraints { make  in
            make.center.equalToSuperview()
        }
        
        self.closeBtn.snp_makeConstraints { make  in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kSheetListButton_W, height: kSheetListTop_H))
        }
        
    }

    internal lazy var topView: UIView = {
        let topV = UIView(frame: CGRect(x: 0, y: 0, width: self.xb_contentView!.bounds.width, height: kSheetListTop_H))
        topV.backgroundColor = UIColor.white
        
        return topV
    }()

    // MARK: 懒加载 列表
    internal lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: kSheetListTop_H, width: self.xb_contentView!.bounds.width, height: self.xb_contentView!.bounds.height - kSheetListTop_H), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.rowHeight = rowHeight
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        
        return table
    }()
    
    internal lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(sheetListBtnAction(sender:)), for: .touchUpInside)
        btn.tag = 1000
        btn.isHidden = true
        
        return btn
    }()

    internal lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(sheetListBtnAction(sender:)), for: .touchUpInside)
        btn.tag = 1001
        
        return btn
    }()
    
    internal lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "请选择"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
  
        return label
    }()
    
    
}


extension xbBaseSheetListController: UITableViewDelegate,UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.backgroundColor = UIColor.orange
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        xb_dismiss()
        if let block = self.didSelectRowAtBlock {
            block(self, indexPath.row)
        }
    }
    
}

