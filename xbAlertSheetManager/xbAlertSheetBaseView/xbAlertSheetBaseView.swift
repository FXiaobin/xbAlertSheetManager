//
//  xbAlertSheetBaseView.swift
//  FSCycleSwift
//
//  Created by huadong on 2022/1/26.
//

import UIKit

public enum xbAlertSheetBaseViewType {
    case alert
    case fromBottom
    case fromTop
    case fromLeft
    case fromeRight
}

public class xbAlertSheetBaseView: UIView {

    fileprivate var maskBg: UIView?
    
    fileprivate var showType: xbAlertSheetBaseViewType = .alert
    
    var maskBgAlpa: CGFloat = 0.3
    
    var centerOffsetY: CGFloat = 0.0
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


public extension xbAlertSheetBaseView {

    @objc fileprivate func bgViewAction() -> () {
        self.xb_dismiss()
    }
    
    func xb_show() {
        xb_show(nil, completed: nil)
    }
    
    func xb_showSheet() {
        xb_show(nil, type: .fromBottom, completed: nil)
    }
    
    func xb_show(_ toView: UIView?, type: xbAlertSheetBaseViewType = .alert, completed: (() -> Void)?) {
        
        var showToView : UIView?
        
        if toView == nil {
            showToView = UIApplication.shared.keyWindow
        }else{
            showToView = toView
        }
        
        showToView?.frame = UIScreen.main.bounds
        let bgView = UIButton(frame: showToView?.bounds ?? UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(maskBgAlpa)
        bgView.alpha = 0.0
        bgView.adjustsImageWhenHighlighted = false
        bgView.addTarget(self, action: #selector(bgViewAction), for: .touchUpInside)
        maskBg = bgView
        
        showToView?.addSubview(bgView)
        showToView?.addSubview(self)
        
        showType = type
        
        switch type {
        case .alert:
            
            var frame: CGRect = self.frame
            frame.origin.x = (UIScreen.main.bounds.width - frame.size.width)/2.0
            frame.origin.y = ((UIScreen.main.bounds.height - frame.size.height)/2.0 + centerOffsetY)
            self.frame = frame
            
            /*
            bgView.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.2) {
                bgView.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

            } completion: { finished in

                UIView.animate(withDuration: 1.0/15.0) {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

                } completion: { finished in
                    UIView.animate(withDuration: 1.0/7.5) {
                        self.transform = CGAffineTransform.identity


                    } completion: { finished in
                        if let block = completed{
                            block()
                        }
                    }
                }
            }
            */
            
            
            bgView.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.15) {
                bgView.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                
            } completion: { finished in
                
                UIView.animate(withDuration: 1.0/10.0) {
                    self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                   
                } completion: { finished in
                    UIView.animate(withDuration: 1.0/10) {
                        self.transform = CGAffineTransform.identity
                        
                        
                    } completion: { finished in
                        if let block = completed{
                            block()
                        }
                    }
                }
            }
            
            break
            
        case .fromTop:
            
            var frame: CGRect = self.frame
            frame.origin.x = (UIScreen.main.bounds.width - frame.size.width)/2.0
            frame.origin.y = -frame.size.height
            self.frame = frame
            
            bgView.alpha = 0.0
            UIView.animate(withDuration: 0.25) {
                bgView.alpha = 1.0
                
                var rect: CGRect = self.frame
                rect.origin.y = 0.0
                self.frame = rect
                
            } completion: { finished in
                if let block = completed{
                    block()
                }
            }
            
            break
            
        case .fromBottom:
            var frame: CGRect = self.frame
            frame.origin.x = (UIScreen.main.bounds.width - frame.size.width)/2.0
            frame.origin.y = UIScreen.main.bounds.size.height
            self.frame = frame
            
            bgView.alpha = 0.0
            UIView.animate(withDuration: 0.25) {
                bgView.alpha = 1.0
                
                var rect: CGRect = self.frame
                rect.origin.y = UIScreen.main.bounds.size.height - rect.size.height
                self.frame = rect
                
            } completion: { finished in
                if let block = completed{
                    block()
                }
            }
            break
            
        case .fromLeft:
            
            var frame: CGRect = self.frame
            frame.origin.y = (UIScreen.main.bounds.height - frame.size.height)/2.0
            frame.origin.x = -frame.size.width
            self.frame = frame
            
            bgView.alpha = 0.0
            UIView.animate(withDuration: 0.25) {
                bgView.alpha = 1.0
                
                var rect: CGRect = self.frame
                rect.origin.x = 0.0
                self.frame = rect
                
            } completion: { finished in
                if let block = completed{
                    block()
                }
            }
            break
            
            
        case .fromeRight:
            var frame: CGRect = self.frame
            frame.origin.y = (UIScreen.main.bounds.height - frame.size.height)/2.0
            frame.origin.x = UIScreen.main.bounds.width
            self.frame = frame
            
            bgView.alpha = 0.0
            UIView.animate(withDuration: 0.25) {
                bgView.alpha = 1.0
                
                var rect: CGRect = self.frame
                rect.origin.x = (UIScreen.main.bounds.width - rect.size.width)
                self.frame = rect
                
            } completion: { finished in
                if let block = completed{
                    block()
                }
            }
            break
        }
        
        
    }
    
   
    func xb_dismiss(finished: (() -> Void)? = nil){
        
        switch showType {
        case .alert:
            self.maskBg?.alpha = 1.0
            UIView.animate(withDuration: 0.25) {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                self.maskBg?.alpha = 0.0
                self.alpha = 0.0
                
            } completion: { completed in
                self.maskBg?.removeFromSuperview()
                self.removeFromSuperview()
                if let block = finished{
                    block()
                }
            }
            
            break
            
        case .fromTop:
            self.maskBg?.alpha = 1.0
            UIView.animate(withDuration: 0.25) {
                self.maskBg?.alpha = 0.0
                
                var frame: CGRect = self.frame
                frame.origin.y = -frame.size.height
                self.frame = frame
                
            } completion: { completed in
                self.maskBg?.removeFromSuperview()
                self.removeFromSuperview()
                if let block = finished {
                    block()
                }
                
            }
            break
            
        case .fromBottom:
            self.maskBg?.alpha = 1.0
            UIView.animate(withDuration: 0.25) {
                self.maskBg?.alpha = 0.0
                
                var frame: CGRect = self.frame
                frame.origin.y = UIScreen.main.bounds.size.height
                self.frame = frame
                
                
            } completion: { completed in
                self.maskBg?.removeFromSuperview()
                self.removeFromSuperview()
                if let block = finished {
                    block()
                }
                
            }
            break
            
        case .fromLeft:
            self.maskBg?.alpha = 1.0
            UIView.animate(withDuration: 0.25) {
                self.maskBg?.alpha = 0.0
                
                var frame: CGRect = self.frame
                frame.origin.x = -frame.size.width
                self.frame = frame
                
                
            } completion: { completed in
                self.maskBg?.removeFromSuperview()
                self.removeFromSuperview()
                if let block = finished {
                    block()
                }
                
            }
            break
            
            
        case .fromeRight:
            self.maskBg?.alpha = 1.0
            UIView.animate(withDuration: 0.25) {
                self.maskBg?.alpha = 0.0
                
                var frame: CGRect = self.frame
                frame.origin.x = UIScreen.main.bounds.size.width
                self.frame = frame
                
                
            } completion: { completed in
                self.maskBg?.removeFromSuperview()
                self.removeFromSuperview()
                if let block = finished {
                    block()
                }
                
            }
            break
        }
        
        
        
    }
}


extension xbAlertSheetBaseView {
    /** 自定义视图圆角(forView:必须要线设置size) .allCorners 或者 [.topLeft, .topRight, .bottomLeft, .bottomRight]*/
     func xb_alertSheetBaseCornersByRounding(rectCorner: UIRectCorner, cornerRadius: CGFloat) -> () {
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        layer.path = path.cgPath
        
        self.layer.mask = layer
    }
}
