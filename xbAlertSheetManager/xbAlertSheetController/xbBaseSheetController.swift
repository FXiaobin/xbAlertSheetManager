//
//  xbBaseSheetController.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit

public enum xbBaseSheetControllerPopType {
    case fromBottom
    case fromTop
    case fromLeft
    case fromRight
}

private let kWidth = UIScreen.main.bounds.size.width
private let kHeight = UIScreen.main.bounds.size.height

public class xbBaseSheetController: UIViewController {

    public var xb_tapClose: Bool = true
    public var xb_showCornerRad: Bool = true
    
    var xb_contentView: UIView?
    
    fileprivate var xb_popType: xbBaseSheetControllerPopType = .fromBottom
        
    private lazy var bgButton: UIButton = {
        let btn: UIButton = UIButton(frame: self.view.bounds)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(bgButtonAction(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /** 状态栏样式*/
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
   
    /// 重写父类的init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)方法
       
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.xb_tapClose = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.bgButton)
       
        
        xb_customMyContentView()
    
    }
    
    /// 子类需重写 来自定义自己要显示的视图
    public func xb_customMyContentView() {
        
        // 1. 初始化自定义视图
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth - 100, height: 200))
        contentView.backgroundColor = UIColor.white
//        self.view.addSubview(contentView)
        
        // 2. 全局引用
        self.xb_contentView = contentView
        
        // 3. 设置圆角 并添加到self.view上
        if let customView = self.xb_contentView {
            self.view.addSubview(customView)
            
        }else{
            debugPrint("自定义视图不存在，无法弹出视图")
        }
        
    }
   
    
    // MARK: 背景点击事件
    @objc fileprivate func bgButtonAction(sender: UIButton) -> () {
        if !self.xb_tapClose {
            return
        }
        xb_dismiss()
    }
    
    
    
    // MARK: 自定义视图的显示和隐藏
    
    /** present出弹窗*/
    public func xb_showSheetController(showType: xbBaseSheetControllerPopType = .fromBottom, completed: (() -> Void)? = nil) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(self, animated: false) {
                self.xb_show(popType: showType, completed: completed)
            }
        }
    }
 
    /** 显示底部弹窗（带回调）*/
    // block类型仿照系统模态
    fileprivate func xb_show(popType: xbBaseSheetControllerPopType = .fromBottom, completed: (() -> Void)? = nil) {
        
        guard let _ = self.xb_contentView else {
            return
        }
        
        self.xb_popType = popType
       
        self.bgButton.alpha = 0.0
        
        switch popType {
        case .fromBottom:
            var frame = self.xb_contentView!.frame
            frame.origin.y = kHeight
            self.xb_contentView?.frame = frame
            
            let center = self.xb_contentView!.center
            self.xb_contentView?.center = CGPoint(x: kWidth / 2.0, y: center.y)
            
            if self.xb_showCornerRad {
                xb_sheetCornersByRounding(rectCorner: [.topLeft, .topRight], cornerRadius: 10.0)
            }

            break
            
        case .fromTop:
            var frame = self.xb_contentView!.frame
            frame.origin.y = -frame.size.height
            self.xb_contentView?.frame = frame
            
            let center = self.xb_contentView!.center
            self.xb_contentView?.center = CGPoint(x: kWidth / 2.0, y: center.y)
            
            if self.xb_showCornerRad {
                xb_sheetCornersByRounding(rectCorner: [.bottomLeft, .bottomRight], cornerRadius: 10.0)
            }

            break
            
        case .fromLeft:
            var frame = self.xb_contentView!.frame
            frame.origin.x = -frame.size.width
            self.xb_contentView?.frame = frame
            
            let center = self.xb_contentView!.center
            self.xb_contentView?.center = CGPoint(x: center.x, y: kHeight / 2.0)
            
            if self.xb_showCornerRad {
                xb_sheetCornersByRounding(rectCorner: [.bottomRight, .topRight], cornerRadius: 10.0)
            }

            break
            
        case .fromRight:
            var frame = self.xb_contentView!.frame
            frame.origin.x = kWidth
            self.xb_contentView?.frame = frame
            
            let center = self.xb_contentView!.center
            self.xb_contentView?.center = CGPoint(x: center.x, y: kHeight / 2.0)
            
            if self.xb_showCornerRad {
                xb_sheetCornersByRounding(rectCorner: [.topLeft, .bottomLeft], cornerRadius: 10.0)
            }

            break
        }
        
        
        UIView.animate(withDuration: 0.25) {
            self.bgButton.alpha = 1.0
            
            switch popType {
            case .fromBottom:
                var frame = self.xb_contentView!.frame
                frame.origin.y -= (frame.size.height)
                self.xb_contentView?.frame = frame
                break
                
            case .fromTop:
                var frame = self.xb_contentView!.frame
                frame.origin.y += (frame.size.height)
                self.xb_contentView?.frame = frame
                break
                
            case .fromLeft:
                var frame = self.xb_contentView!.frame
                frame.origin.x += (frame.size.width)
                self.xb_contentView?.frame = frame
                break
                
            case .fromRight:
                var frame = self.xb_contentView!.frame
                frame.origin.x -= (frame.size.width)
                self.xb_contentView?.frame = frame
                break
            }
          
        } completion: { completion in
            if let block = completed{
                block()
            }
        }

    }
    
    /** 隐藏底部弹窗（带回调） */
    public func xb_dismiss(completed: (() -> Void)? = nil) {
        guard let _ = self.xb_contentView else {
            return
        }
        
        self.bgButton.alpha = 1.0
        
        UIView.animate(withDuration: 0.25) {
            self.bgButton.alpha = 0.0
            
            switch self.xb_popType {
            case .fromBottom:
                var frame = self.xb_contentView!.frame
                frame.origin.y = kHeight
                self.xb_contentView?.frame = frame
                break
                
            case .fromTop:
                var frame = self.xb_contentView!.frame
                frame.origin.y -= (frame.size.height)
                self.xb_contentView?.frame = frame
                break
                
            case .fromLeft:
                var frame = self.xb_contentView!.frame
                frame.origin.x -= (frame.size.width)
                self.xb_contentView?.frame = frame
                break
                
            case .fromRight:
                var frame = self.xb_contentView!.frame
                frame.origin.x += (frame.size.width)
                self.xb_contentView?.frame = frame
                break
            }
            
        } completion: { completion in
            self.xb_contentView?.removeFromSuperview()
            self.dismiss(animated: false, completion: nil)
            
            if let block = completed{
                block()
            }
        }

    }
   
}

public extension xbBaseSheetController {
    /** 自定义视图圆角(forView:必须要线设置size) .allCorners 或者 [.topLeft, .topRight, .bottomLeft, .bottomRight]*/
    func xb_sheetCornersByRounding(rectCorner: UIRectCorner, cornerRadius: CGFloat) -> () {
        
        let layer = CAShapeLayer()
        layer.frame = xb_contentView!.bounds
        
        let path = UIBezierPath(roundedRect: xb_contentView!.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        layer.path = path.cgPath
        
        xb_contentView?.layer.mask = layer
    }
}
