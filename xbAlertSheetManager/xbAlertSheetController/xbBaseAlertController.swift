//
//  xbBaseAlertController.swift
//  xbAlertSheetManager
//
//  Created by huadong on 2022/1/26.
//

import UIKit

class xbBaseAlertController: UIViewController {

    var xb_tapClose: Bool = false
    
    var xb_contentView: UIView?
    
    /** 中心Y偏移量，正数向下，负数向上*/
    var xb_offSetY: CGFloat = 0.0{
        didSet{
            var center = self.view.center
            center.y += xb_offSetY
            self.xb_contentView?.center = center
        }
    }
        
    private lazy var bgButton: UIButton = {
        let btn: UIButton = UIButton(frame: self.view.bounds)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(bgButtonAction(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /** 状态栏样式*/
    override var preferredStatusBarStyle: UIStatusBarStyle{
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.bgButton)
       
        
        xb_customMyContentView()
    
    }
   
    /// 子类需重写 来自定义自己要显示的视图
    func xb_customMyContentView() {
        
        // 1. 初始化自定义视图
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        contentView.backgroundColor = UIColor.white
//        self.view.addSubview(contentView)
        
        // 2. 全局引用，并设置为中心位置
        contentView.center = self.view.center
        self.xb_contentView = contentView
        
        
        // 3. 设置圆角 并添加到self.view上
        if let customView = self.xb_contentView {
            self.xb_addRoundingCorners(cornerRad: CGSize(width: 10.0, height: 10.0))
            self.view.addSubview(customView)
            
        }else{
            debugPrint("自定义视图不存在，无法弹出视图")
        }
        
    }
    
    
    // MARK: 背景点击事件
    @objc private func bgButtonAction(sender: UIButton) -> () {
        if !self.xb_tapClose {
            return
        }
        xb_dismiss()
    }
    
    // MARK: 自定义视图的显示和隐藏
    
    /** present出弹窗*/
    func xb_showAlertController() {
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(self, animated: false) {
                self.xb_show()
            }
        }
    }
    
    /** 显示底部弹窗 */
    private func xb_show(){
        xb_show(completed: nil)
    }
    
    /** 显示底部弹窗（带回调）*/
    // block类型仿照系统模态
    private func xb_show(completed: (() -> Void)? = nil) {
        
        guard let _ = self.xb_contentView else {
            return
        }
        
        //self.contentView?.layer.add(p_defaultAlertShowAnimation(), forKey: "show")
        
        //*
        self.bgButton.alpha = 0.0
        self.xb_contentView?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2) {
            self.bgButton.alpha = 1.0
            self.xb_contentView?.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)

        } completion: { completion in
            
            UIView.animate(withDuration: 1.0/10.0) {
                self.xb_contentView?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)

            } completion: { completion in
                UIView.animate(withDuration: 1.0/10) {
                    self.xb_contentView?.transform = CGAffineTransform.identity
                    
                } completion: { completion in
                    if let block = completed{
                        block()
                    }
                }
            }
        }
     //*/
    }
    
    /** 隐藏底部弹窗 */
    func xb_dismiss(){
        xb_dismiss(completed: nil)
    }
    
    /** 隐藏底部弹窗（带回调） */
    func xb_dismiss(completed: (() -> Void)? = nil) {
        guard let _ = self.xb_contentView else {
            return
        }
        
        self.bgButton.alpha = 1.0
        self.xb_contentView?.alpha = 1.0
        UIView.animate(withDuration: 0.25) {
            self.bgButton.alpha = 0.0
            self.xb_contentView?.alpha = 0.0
            
        } completion: { completion in
            self.xb_contentView?.removeFromSuperview()
            self.dismiss(animated: false, completion: nil)
            
            if let block = completed{
                block()
            }
        }

    }
    
    
    /**
     *   展示动画
     */
   private func p_defaultAlertShowAnimation() -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.25
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        var values : [Any] = []
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        return animation
    }
    
    /**
     *   设置控件为圆角
     */
    private func xb_addRoundingCorners(cornerRad: CGSize)  {
        let path = UIBezierPath(roundedRect: (xb_contentView?.bounds)!, byRoundingCorners: UIRectCorner(rawValue: UInt(UInt8(UIRectCorner.topRight.rawValue)|UInt8(UIRectCorner.topLeft.rawValue)|UInt8(UIRectCorner.bottomLeft.rawValue)|UInt8(UIRectCorner.bottomRight.rawValue))), cornerRadii: cornerRad)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        xb_contentView?.layer.mask = shapeLayer
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
