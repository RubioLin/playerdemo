import UIKit

class BezierText: UIView {
    //動畫時間
    private let duration:TimeInterval = 4
     
    //書寫圖層
    private let pathLayer = CAShapeLayer()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        //初始化字跡圖層
        pathLayer.frame = self.bounds
        pathLayer.isGeometryFlipped = true
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 2
        pathLayer.strokeColor = UIColor(named: "mainColor")?.cgColor
        self.layer.addSublayer(pathLayer)
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    //動態書寫指定文字
    func show(text: String) {
        //獲取文字對應的貝塞爾曲線
        let textPath = bezierPathFrom(string: text)
         
        //讓文字居中顯示
        pathLayer.bounds = textPath.cgPath.boundingBox
        //設置筆記書寫路徑
        pathLayer.path = textPath.cgPath
         
        //添加筆跡書寫動畫
        let textAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        textAnimation.duration = duration
        textAnimation.fromValue = 0
        textAnimation.toValue = 1
        //textAnimation.repeatCount = HUGE
        pathLayer.add(textAnimation, forKey: "strokeEnd")
        
    }
    
    
     
    //將字元串轉為貝塞爾曲線
    private func bezierPathFrom(string:String) -> UIBezierPath{
        let paths = CGMutablePath()
        let fontName = __CFStringMakeConstantString("SnellRoundhand")!
        let fontRef:AnyObject = CTFontCreateWithName(fontName, 60, nil)
         
        let attrString = NSAttributedString(string: string, attributes:
                                                [kCTFontAttributeName as NSAttributedString.Key : fontRef])
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runA = CTLineGetGlyphRuns(line)
         
        for runIndex in 0..<CFArrayGetCount(runA) {
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, to: CTRun.self)
             
            let CTFontName = unsafeBitCast(kCTFontAttributeName,
                                           to: UnsafeRawPointer.self)
             
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)
             
            let width = UIScreen.main.bounds.width
             
            var temp = 0
            var offset:CGFloat = 0.0
             
            for i in 0..<CTRunGetGlyphCount(runb) {
                let range = CFRangeMake(i, 1)
                let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                let position = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                position.initialize(to: .zero)
                CTRunGetGlyphs(runb, range, glyph)
                CTRunGetPositions(runb, range, position);
                 
                let temp3 = CGFloat(position.pointee.x)
                let temp2 = (Int) (temp3 / width)
                let temp1 = 0
                if(temp2 > temp1){
                     
                    temp = temp2
                    offset = position.pointee.x - (CGFloat(temp) * width)
                }
                if let path = CTFontCreatePathForGlyph(runFontS,glyph.pointee,nil) {
                    let x = position.pointee.x - (CGFloat(temp) * width) - offset
                    let y = position.pointee.y - (CGFloat(temp) * 80)
                    let transform = CGAffineTransform(translationX: x, y: y)
                    paths.addPath(path, transform: transform)
                }
                
                glyph.deinitialize(count: 1)
                glyph.deallocate()
                position.deinitialize(count: 1)
                position.deallocate()
            }
        }
         
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.append(UIBezierPath(cgPath: paths))
         
        return bezierPath
    }
}
