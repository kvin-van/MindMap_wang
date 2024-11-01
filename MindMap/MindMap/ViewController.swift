//
//  ViewController.swift
//  MindMap
//
//  Created by kevin_wang on 2024/9/13.
//

import UIKit

var kScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let detailMindMapView : DetailMindMapView = DetailMindMapView()
//        detailMindMapView.bindData(mindMapContentStr)
        self.view.addSubview(detailMindMapView)
        detailMindMapView.frame = CGRectMake(0, 100, kScreenWidth, detailMindMapView.viewHeight)
    }

}

extension UIColor{
    //16位 颜色
    class func colorHex(hexStr: String,alpha: CGFloat = 1.0) -> UIColor? {
        // 存储转换后的数值
        var alp: UInt64 = 255, red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = hexStr
        // 去前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        
        // 解析8位 前2位为透明度
        if hex.count == 8 {
            let string1 = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])
            let string2 = String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])
            let string3 = String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)])
            let string4 = String(hex[hex.index(hex.startIndex, offsetBy: 6)..<hex.index(hex.startIndex, offsetBy: 8)])
                    
            Scanner(string: string1).scanHexInt64(&alp)
            Scanner(string: string2).scanHexInt64(&red)
            Scanner(string: string3).scanHexInt64(&green)
            Scanner(string: string4).scanHexInt64(&blue)

            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alp)/255.0)
        }
        
        // 解析6位 无透明度
        if hex.count == 6 {
            let string1 = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])
            let string2 = String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])
            let string3 = String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)])
                    
            Scanner(string: string1).scanHexInt64(&red)
            Scanner(string: string2).scanHexInt64(&green)
            Scanner(string: string3).scanHexInt64(&blue)
            
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
            
        }
        return nil
    }
}

