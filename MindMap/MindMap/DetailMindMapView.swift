//
//  DetailMindMapView.swift
//  AiNews
//  Created by kevin_wang on 2023/9/3.
//方法： 递归
//思路：从最后一列开始算 1.换了父类加间隔 2.如果父类没有子类就把父类的高度延伸到子类的列的高度中。3.父类的高度取子类起始结束的高度的中间值

import Foundation
import UIKit

struct NodeModel {
    var storey : CGFloat = 0.0
    var upperName : String?
    var name : String = ""
    var lowerArr : [NodeModel]?
}

class DetailMindMapView: UIView {
    
    let canvasView : UIView = UIView() //画布
    
    private var storeyWidthDic : Dictionary<CGFloat,CGFloat>! //每级的宽
    private var storeyXDic : Dictionary<CGFloat,CGFloat>!   //每级的x起点
    private var horizontalSpacing : CGFloat = 70.0
    private var lastVerticalSpacing : CGFloat = 20.0
    var labFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    private var colorArr2 : Dictionary<Int,String> = [0:"FF2329",1:"FF9B35",2:"F9D200",3:"00BF75",4:"3D6BFF",5:"4E49C5"]
    private var colorArr3 : Dictionary<Int,String> = [0:"FFD7D7",1:"FF9B35",2:"FFF6CF",3:"C1F3E4",4:"D8E1FF",5:"DBDBF4"]
    private var colorArr4 : Dictionary<Int,String> = [:]
    
    private var frame1 : [CGRect] = []
    private var frame2 : Dictionary<String,CGRect> = [:]
    private var frame3 : Dictionary<String,[Dictionary<String,CGRect>]> = [:]
    private var frame4 : Dictionary<String,[CGRect]> = [:]
    
    private var lastHeight : CGFloat = 0.0 //最后一列高度Y 至关重要
    private var lastupperName = "****" //初始化
    private var findNoChildren : CGFloat = 0
    private var frameDic : Dictionary<String,(start:CGFloat,end:CGFloat)> = [:]

    var viewHeight : CGFloat {
        get{
            return canvasView.frame.size.height
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        canvasView.backgroundColor = .white
        canvasView.layer.cornerRadius = 12
        self.addSubview(canvasView)
        storeyWidthDic =  [0.0:150,1.0:120,2.0:120,3.0:100]
        storeyXDic =  [0.0:20, 1.0:20+storeyWidthDic[0.0]!+horizontalSpacing,2.0:20+storeyWidthDic[0.0]!+storeyWidthDic[1.0]!+horizontalSpacing*2,3.0:20+storeyWidthDic[0.0]!+storeyWidthDic[1.0]!+storeyWidthDic[2.0]!+horizontalSpacing*3]
        
//        let node111_1 = NodeModel(storey:3.0,upperName:"思维导图 测试1",name:"思维导图测试node111_1")
//        let node111_2 = NodeModel(storey:3.0,upperName:"思维导图 测试1",name:"思维导图测试node111_2")
//        let node444_1 = NodeModel(storey:3.0,upperName:"思维导图测试4",name:"思维导图 2测试4444")
//        let node555_1 = NodeModel(storey:3.0,upperName:"思维导图测试5",name:"思维导图 2测试5555")
//        let node999_1 = NodeModel(storey:3.0,upperName:"思维导图测试9",name:"思维导图测试999")
//        let node111 = NodeModel(storey:2.0,upperName:"计划描述",name:"思维导图 测试1",lowerArr:[node111_1,node111_2])
        let node111 = NodeModel(storey:2.0,upperName:"计划描述",name:"思维导图 测试1")
        let node222 = NodeModel(storey:2.0,upperName:"计划描述",name:"思维导图 1测试2")
        let node333 = NodeModel(storey:2.0,upperName:"计划描述",name:"思维导图 1测试3")
//        let node444 = NodeModel(storey:2.0,upperName:"参与者",name:"思维导图测试4",lowerArr:[node444_1])
        let node444 = NodeModel(storey:2.0,upperName:"参与者",name:"思维导图测试4")
//        let node555 = NodeModel(storey:2.0,upperName:"参与者",name:"思维导图测试5",lowerArr:[node555_1])
        let node555 = NodeModel(storey:2.0,upperName:"参与者",name:"思维导图测试5")
        let node666 = NodeModel(storey:2.0,upperName:"太空行走33",name:"思维导图 3测试6")
        let node777 = NodeModel(storey:2.0,upperName:"太空行走33",name:"思维导图 3测试7")
        let node888 = NodeModel(storey:2.0,upperName:"科学研究🚀",name:"思维导图 测试8")
//        let node999 = NodeModel(storey:2.0,upperName:"科学研究🚀",name:"思维导图测试9",lowerArr:[node999_1])
        let node999 = NodeModel(storey:2.0,upperName:"科学研究🚀",name:"思维导图测试9")
        let node11 = NodeModel(storey:1.0,upperName:"太空行走计划🍊",name:"计划描述",lowerArr:[node111,node222,node333])
        let node22 = NodeModel(storey:1.0,upperName:"太空行走计划🍊",name:"参与者",lowerArr:[node444,node555])
        let node33 = NodeModel(storey:1.0,upperName:"太空行走计划🍊",name:"太空行走33",lowerArr:[node666,node777])
        let node44 = NodeModel(storey:1.0,upperName:"太空行走计划🍊",name:"科学研究🚀",lowerArr:[node888,node999])
//        
        let node1 = NodeModel(storey:0.0,upperName:nil,name:"太空行走计划🍊",lowerArr:[node11,node22,node33,node44])
        
        let tempWidth = kScreenWidth
        mindMap(fatherNode:nil,node: node1,deep: 2.0,index:0)
        canvasView.frame = CGRect(x: 0, y: 0, width: storeyXDic[2.0]!+storeyWidthDic[2.0]!+20, height: lastHeight+20)
        drawLineAction(deep: 2.0)
        canvasView.transform =  CGAffineTransform(scaleX:tempWidth/canvasView.frame.size.width, y: tempWidth/canvasView.frame.size.width)
        canvasView.frame = CGRect(x: 0, y: 0, width: tempWidth, height: self.viewHeight)
        
        
//        mindMap(fatherNode:nil,node: node1,deep: 3.0,index:0)
//        canvasView.frame = CGRect(x: 0, y: 0, width: storeyXDic[3.0]!+storeyWidthDic[3.0]!+20, height: lastHeight+20)
//        drawLineAction(deep: 3.0)
//        canvasView.transform =  CGAffineTransform(scaleX:tempWidth/canvasView.frame.size.width, y: tempWidth/canvasView.frame.size.width)
//        canvasView.frame = CGRect(x: 0, y: 0, width: tempWidth, height: self.viewHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //根据字符串 生成脑图数据
    func bindData(_ mapStr : String) -> Void {
        let array = mapStr.components(separatedBy: "\n")
        var node1 = NodeModel(storey:0.0,upperName:nil)
        var children2Arr : [NodeModel] = []
        var children3Arr : [NodeModel] = []
        var children4Arr : [NodeModel] = []
        var step2Flag = -1
        var step3Flag = -1
        var type = 1 //对应多种数据结构
        for (index,string) in array.enumerated(){
            if index == 0 {
                var mainStr = ""
                if string.hasPrefix("-")||string.hasPrefix(" -"){
                    type = 1
                    mainStr = string.replacingOccurrences(of: "*", with: "")
                    mainStr = mainStr.replacingOccurrences(of: "-", with: "")
                }else{
                    type = 2
                    mainStr = string.replacingOccurrences(of: "*", with: "")
                }
                node1.name = mainStr
                continue
            }
            
            if (type == 1 && string.hasPrefix("  ") && !string.hasPrefix("    ")) || 
                (type == 2 && string.hasPrefix("- ") && !string.hasPrefix("  - ")) ||
                (type == 2 && string.hasPrefix("- ") && !string.hasPrefix(" - ")){
                var string2 = string.replacingOccurrences(of: "*", with: "")
                    string2 = string2.replacingOccurrences(of: "  ", with: "")
                string2 = string2.replacingOccurrences(of: "- ", with: "")
                    let node2 = NodeModel(storey:1.0,upperName:node1.name,name:string2)
                    children2Arr.append(node2)
                node1.lowerArr = children2Arr
                step2Flag = step2Flag + 1
                children3Arr.removeAll()
                step3Flag = -1
            }
            else if string.hasPrefix("    ") || string.hasPrefix("  - ") || string.hasPrefix(" - "){
                if children2Arr.count > step2Flag{
                    var node22 = children2Arr[step2Flag]
                    var string3 = string.replacingOccurrences(of: "*", with: "")
                    string3 = string3.replacingOccurrences(of: "  ", with: "")
                    string3 = string3.replacingOccurrences(of: "  - ", with: "")
                    string3 = string3.replacingOccurrences(of: "- ", with: "")
                    let node3 = NodeModel(storey:2.0,upperName:node22.name,name:string3)
                    children3Arr.append(node3)
                    node22.lowerArr = children3Arr
                    children2Arr[step2Flag] = node22
                    step3Flag = step3Flag + 1
                    children4Arr.removeAll()
                }
            }
            else{
            }
        }
        node1.lowerArr = children2Arr
        let tempWidth = kScreenWidth - 70
        mindMap(fatherNode:nil,node: node1,deep: 2.0,index:0)
        canvasView.frame = CGRect(x: 0, y: 0, width: storeyXDic[2.0]!+storeyWidthDic[2.0]!+20, height: lastHeight+20)
        drawLineAction(deep: 2.0)
        canvasView.transform =  CGAffineTransform(scaleX:tempWidth/canvasView.frame.size.width, y: tempWidth/canvasView.frame.size.width)
        canvasView.frame = CGRect(x: 0, y: 0, width: tempWidth, height: self.viewHeight)
    }
    
    func mindMap(fatherNode:NodeModel?, node:NodeModel,deep:CGFloat,index:Int) {
        
        if let array = node.lowerArr ,array.count > 0{
            for (i , value) in array.enumerated(){
//                NSLogs(i,value)
                mindMap(fatherNode:node,node: value,deep: deep,index:i)
            }
        }
        else if node.storey != deep{ //不是最后  且 没有子集
            let noChildrenHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey] ?? 100)
            findNoChildren  = findNoChildren + noChildrenHeight
            frameDic[node.name] = (lastHeight+lastVerticalSpacing,lastHeight+lastVerticalSpacing+noChildrenHeight)//启新组的值 Y的起点和终点maxY
            lastHeight = lastHeight+lastVerticalSpacing+noChildrenHeight
//            NSLogs(node.name,frameDic[node.name])
        }
        
        let lab = makeLab(fatherNode:fatherNode,node: node,deep:deep,index:index)
//        NSLogs(node.name,"=",lab.frame)
        if node.storey == 0.0{
            frame1.append(lab.frame)
        }
        else if node.storey == 1.0{
            frame2[node.name] = lab.frame
        }
        else if node.storey == 2.0{
            if var array = frame3[node.upperName ?? ""]{
                array.append([node.name:lab.frame])
                frame3[node.upperName ?? ""] = array
            }else{
                frame3[node.upperName ?? ""] = [[node.name:lab.frame]]
            }
        }
        else if node.storey == 3.0{
            if var array = frame4[node.upperName ?? ""]{
                array.append(lab.frame)
                frame4[node.upperName ?? ""] = array
            }else{
                frame4[node.upperName ?? ""] = [lab.frame]
            }
        }
        
    }
    
    func makeLab(fatherNode:NodeModel?,node:NodeModel,deep:CGFloat,index:Int) -> UILabel{
        if node.upperName != nil , lastupperName != node.upperName{ //顺序不变
            if node.storey == deep{ //最后一竖排
                lastHeight = lastHeight + 20
                frameDic[node.upperName ?? ""] = (lastHeight,lastHeight)//启新组的值 Y的起点和终点maxY
                lastupperName = node.upperName ?? ""
            }
            else{//中间
                if let _ = frameDic[node.upperName ?? ""]{ //有父类了
                }else{ //中间组第一个
//                    NSLogs(node.name,frameDic[node.name])
                    if let tupe = frameDic[node.name]{
                        let middleNodeHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey] ?? 100)
                        let middleY = tupe.start + (tupe.end - tupe.start - middleNodeHeight)/2
                        frameDic[node.upperName ?? ""] = (middleY,middleY)//Y的起点和终点maxY
                    }
                }
            }
        }
        else if node.storey == deep{
            lastHeight = lastHeight + 10 //10最后一竖排 间隔
        }
        
        
        let lab = UILabel()
        lab.textAlignment = .left
        lab.textColor = .black
        lab.font = labFont
        lab.numberOfLines = 0
        lab.adjustsFontSizeToFitWidth = true
        lab.text = node.name
        
        if node.storey == 0.0{
            let strHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey]!)
            var y0 = 0.0
            if let tupe0 = frameDic[node.name]{
                 y0 = tupe0.start + (tupe0.end - tupe0.start - strHeight)/2
            }
//            let presetSize = CGSize(width: storeyWidthDic[node.storey]!, height: strHeight)
//            let newSize = lab.sizeThatFits(presetSize)
//            lab.frame = CGRect(x:storeyXDic[node.storey]!+storeyWidthDic[node.storey]! - newSize.width, y: y0, width: newSize.width, height: strHeight)
            lab.frame = CGRect(x:storeyXDic[node.storey]!, y: y0, width: storeyWidthDic[node.storey]!, height: strHeight)
        }
        
        if node.storey == 1.0{
            var strHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey]!)
            var y1 = 0.0
            if let tupe1 = frameDic[node.name]{
                let  tupe1Middle = (tupe1.end - tupe1.start - strHeight)/2
                 y1 = tupe1.start + (tupe1Middle > 0 ? tupe1Middle : 0) // 如果子集的高小于 父类的高度的时候 取0 不让取负数
                
                if tupe1.start+strHeight > tupe1.end{ //父类的高度大于子集的高度
                    strHeight = tupe1.end - tupe1.start
                }
            }
            lab.frame = CGRect(x: storeyXDic[node.storey]!, y: y1, width: storeyWidthDic[node.storey]!, height: strHeight)
        }
        
        if node.storey == 2.0 && node.storey == deep{
            let strHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey]!)
            
            lab.frame = CGRect(x:storeyXDic[node.storey]!, y: lastHeight, width: storeyWidthDic[node.storey]!, height: strHeight)
            lastHeight = lastHeight + strHeight
        }
        else if node.storey == 2.0{
            let strHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey]!)
            var y2 = 0.0
            if let tupe2 = frameDic[node.name]{
                let  tupe2Middle = (tupe2.end - tupe2.start - strHeight)/2
                y2 = tupe2.start + (tupe2Middle > 0 ? tupe2Middle : 0) // 如果子集的高小于 父类的高度的时候 取0 不让取负数
                if node.lowerArr?.count == 1,tupe2.start+strHeight < tupe2.end{ //子集为1的时候 和子集底边对齐
                    y2 = tupe2.end - strHeight
                }
            }
            lab.frame = CGRect(x: storeyXDic[node.storey]!, y: y2, width: storeyWidthDic[node.storey]!, height: strHeight)
            
        }
        if node.storey == 3.0{
            let strHeight = getStringHeight(string: node.name, font: labFont, width: storeyWidthDic[node.storey]!)
            lab.frame = CGRect(x: storeyXDic[node.storey]!, y: lastHeight, width: storeyWidthDic[node.storey]!, height: strHeight)
            lastHeight = lastHeight + strHeight
        }
        
        if node.storey == deep{
            if var tupe = frameDic[lastupperName]{ //设置上一个的结束值
                tupe.end = lastHeight
                frameDic[lastupperName] = tupe
            }
        }
        else{
            if var tupe = frameDic[node.upperName ?? ""]{ //中间层 设置上一个的结束值
                tupe.end = lab.frame.origin.y + lab.frame.size.height
                frameDic[node.upperName ?? ""] = tupe
            }
        }
        
        canvasView.addSubview(lab)
//        lab.backgroundColor = .lightGray
        return lab
    }
    
    //画线
    func drawLineAction(deep:CGFloat){
        
        var rootPoint :CGPoint!
        for (_ ,rect) in frame1.enumerated(){
           
            let path = UIBezierPath()
            let point1 = CGPoint(x: rect.minX, y: rect.maxY+1)
            let point2 = CGPoint(x: rect.maxX, y: rect.maxY+1)
            path.move(to: point1)
            path.addLine(to: point2)
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: point2.x+4, y: point2.y), radius:4 , startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
            path.append(circlePath)
            // 使用路径绘制
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.fillColor = nil
            shapeLayer.lineWidth = 1.5
            canvasView.layer.addSublayer(shapeLayer)
            
            rootPoint = CGPoint(x: point2.x+9, y: point2.y)
        }
         
        
        for (index,keyStr2) in frame2.keys.enumerated(){
            let rect = frame2[keyStr2]!
            let point1 = CGPoint(x: rect.minX-5, y: rect.maxY+1)  //-10  给前面留白
            let point2 = CGPoint(x: rect.maxX, y: rect.maxY+1)

            let deltaX = point1.x - rootPoint.x   // 计算两点之间的x和y差值
            let deltaY : CGFloat = abs(CGFloat(point1.y - rootPoint.y))
//            NSLogs("deltaX:",deltaX)
//            NSLogs("deltaY:",deltaY)
            let path2 = UIBezierPath()
            path2.lineCapStyle = .round
            path2.move(to: rootPoint)
            path2.addCurve(to: point1, controlPoint1:CGPoint(x: rootPoint.x+(deltaX*deltaY/deltaX*0.3), y: rootPoint.y), controlPoint2: CGPoint(x: point1.x-(deltaX*deltaY/deltaX*0.6), y: point1.y))
            path2.move(to: point1)
            path2.addLine(to: point2)
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: point2.x+4, y: point2.y), radius:4 , startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
            path2.append(circlePath)
            
            let shapeLayer2 = CAShapeLayer()
            shapeLayer2.path = path2.cgPath
            shapeLayer2.strokeColor = UIColor.colorHex(hexStr: colorArr2[index%6] ?? "000000")!.cgColor
            shapeLayer2.fillColor = nil
            shapeLayer2.lineWidth = 1.5
            canvasView.layer.addSublayer(shapeLayer2)
            
            let rootPoint2 :CGPoint = CGPoint(x: point2.x+9, y: point2.y)
                if let rectArr = frame3[keyStr2]{ // 2.0
                    for dictionary in rectArr{
                        for keyStr3 in dictionary.keys{
                            if let tempRect3 = dictionary[keyStr3]{
                                let point1 = CGPoint(x: tempRect3.minX-5, y: tempRect3.maxY+1) //-5  给前面留白
                                let point2 = CGPoint(x: tempRect3.maxX, y: tempRect3.maxY+1)
                                
                                let deltaX3_1 = point1.x - rootPoint2.x
                                let deltaY3_1 : CGFloat = abs(CGFloat(point1.y - rootPoint2.y))
                                
                                let cgColor3 = UIColor.colorHex(hexStr: colorArr3[index%6] ?? "000000")!.cgColor
                                //3节 1段
                                    let lastPath3_1 = UIBezierPath()
                                lastPath3_1.lineCapStyle = .round
                                lastPath3_1.move(to: rootPoint2)
                                
                                lastPath3_1.addCurve(to: point1, controlPoint1:CGPoint(x: rootPoint2.x+(deltaX3_1*deltaY3_1/deltaX3_1*0.3), y: rootPoint2.y), controlPoint2: CGPoint(x: point1.x-(deltaX3_1*deltaY3_1/deltaX3_1*0.6), y: point1.y))
                                
                                let shapeLayer3_1 = CAShapeLayer()
                                shapeLayer3_1.path = lastPath3_1.cgPath
                                shapeLayer3_1.strokeColor = cgColor3
                                shapeLayer3_1.fillColor =  nil
                                shapeLayer3_1.lineWidth = 1.5
                                canvasView.layer.addSublayer(shapeLayer3_1)
                                //3节 2段
                                let lastPath3_2 = UIBezierPath()
                                lastPath3_2.lineCapStyle = .round
                                lastPath3_2.move(to: point1)
                                lastPath3_2.addLine(to: point2)
                                let circlePath = UIBezierPath(arcCenter: CGPoint(x: point2.x+4, y: point2.y), radius:4 , startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
                                lastPath3_2.append(circlePath)
                                let shapeLayer3_2 = CAShapeLayer()
                                shapeLayer3_2.path = lastPath3_2.cgPath
                                shapeLayer3_2.strokeColor = cgColor3
                                shapeLayer3_2.fillColor = deep == 2.0 ? cgColor3 : nil
                                shapeLayer3_2.lineWidth = 1.5
                                canvasView.layer.addSublayer(shapeLayer3_2)
                                    
                                    let rootPoint3 :CGPoint = CGPoint(x: point2.x+9, y: point2.y)
                                if let rectArr4 = frame4[keyStr3]{ // 3.0
                                    for tempRect4 in rectArr4{
                                        let lastPath4 = UIBezierPath()
                                        lastPath4.lineCapStyle = .round
                                        let point41 = CGPoint(x: tempRect4.minX, y: tempRect4.maxY+1)
                                        let point42 = CGPoint(x: tempRect4.maxX, y: tempRect4.maxY+1)
                                        lastPath4.move(to: rootPoint3)
                                        lastPath4.addLine(to: point41)
                                        lastPath4.move(to: point41)
                                        lastPath4.addLine(to: point42)
                                        let circlePath4 = UIBezierPath(arcCenter: CGPoint(x: point42.x+4, y: point42.y), radius:4 , startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
                                        lastPath4.append(circlePath4)
                                        let shapeLayer4 = CAShapeLayer()
                                        shapeLayer4.path = lastPath4.cgPath
                                        let cgColor4 = UIColor.colorHex(hexStr: colorArr3[index%6] ?? "000000")!.cgColor
                                        shapeLayer4.strokeColor = cgColor4
                                        shapeLayer4.fillColor = cgColor4
                                        shapeLayer4.lineWidth = 1.5
                                        canvasView.layer.addSublayer(shapeLayer4)
                                    }
                                }
                            }
                        }
                    }
                    
                }
        }
        
    }
    
    func getStringHeight(string:String,font: UIFont, width: CGFloat) -> CGFloat {
        
        return string.boundingRect(with: CGSize(width:width, height: CGFloat(MAXFLOAT)),
                                 options: .usesLineFragmentOrigin,
                                 attributes: [.font: font],
                                 context: nil).size.height
    }
}
