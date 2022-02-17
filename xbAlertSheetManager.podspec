
 Pod::Spec.new do |spec|

  spec.name         = "xbAlertSheetManager"
  spec.version      = "0.0.3"
  spec.summary      = "xbAlertSheetManager."
  spec.description  = "常用弹窗基类，日期弹窗，选项列表弹窗，xbAlertSheetManager"
  
  spec.requires_arc = true
  spec.license      = "MIT"
  spec.platform     = :ios, "9.0"
  spec.swift_version = "5.0"

  spec.author             = { "xiaobin.fan" => "xiaobin.fan@ecidh.com" }
  spec.homepage     = "https://github.com/FXiaobin/xbAlertSheetManager"
  spec.source       = { :git => "https://github.com/FXiaobin/xbAlertSheetManager.git", :tag => "#{spec.version}" }
  spec.source_files  = "xbAlertSheetManager", "xbAlertSheetManager/**/*.{swift}"
  
  spec.dependency "SnapKit"

end
