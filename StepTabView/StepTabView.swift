import Foundation
import UIKit

class StepTabItem {
    var name = ""
    var imageActive: UIImage!
    var imageComplete: UIImage!
}

class StepTabItemInternal {
    var imageActive: CGImage!
    var imageComplete: CGImage!
}

class StepTabItemGraphics {
    var iconForeground: CALayer!
    var textLayer: CATextLayer!
}

private let ColorCanvas = UIColor(red: CGFloat(0x29) / 255.0, green: CGFloat(0x42) / 255.0, blue: CGFloat(0x99) / 255.0, alpha: 1.0).CGColor
private let ColorFutureTab = UIColor(red: CGFloat(0x1f) / 255.0, green: CGFloat(0x31) / 255.0, blue: CGFloat(0x73) / 255.0, alpha: 1.0).CGColor
private let ColorActiveTab = UIColor(red: CGFloat(0x11) / 255.0, green: CGFloat(0x1b) / 255.0, blue: CGFloat(0x40) / 255.0, alpha: 1.0).CGColor
private let ColorCompleteTab = UIColor.whiteColor().CGColor

class StepTabView: UIView {
    private var tabItems: [StepTabItemInternal]!
    private var tabGraphicsItems = [StepTabItemGraphics]()
    private var rulerLine: CALayer?
    private var pctLine: CALayer?
    private(set) var indicatorIndex = 0
    
    func initTabs(tabItems: [StepTabItem]) {
        releaseItems()
        
        self.tabItems = tabItems.map { (tab: StepTabItem) -> StepTabItemInternal in
            var t = StepTabItemInternal()
            t.imageActive = tab.imageActive.CGImage
            t.imageComplete = tab.imageComplete.CGImage
            return t
        }
        
        var ruler = CALayer()
        ruler.backgroundColor = ColorFutureTab
        ruler.anchorPoint = CGPointZero
        ruler.position = CGPointZero
        self.layer.addSublayer(ruler)
        rulerLine = ruler
        
        var pct = CALayer()
        pct.backgroundColor = ColorCompleteTab
        pct.anchorPoint = CGPointZero
        pct.position = CGPointZero
        self.layer.addSublayer(pct)
        pctLine = pct
        
        for var i = 0; i < tabItems.count; i++ {
            let tab = tabItems[i]
            
            var g = StepTabItemGraphics()
            
            g.iconForeground = CALayer()
            g.iconForeground.backgroundColor = circleColor(i)
            g.iconForeground.bounds = CGRectMake(0, 0, 24, 24)
            g.iconForeground.position = CGPointZero
            g.iconForeground.contents = circleContents(i)
            g.iconForeground.opacity = 1
            g.iconForeground.cornerRadius = 12
            self.layer.addSublayer(g.iconForeground)
            
            g.textLayer = CATextLayer()
            g.textLayer.font = "Arial"
            g.textLayer.fontSize = 12
            g.textLayer.bounds = CGRectMake(0, 0, 200, 20)
            g.textLayer.alignmentMode = kCAAlignmentCenter
            g.textLayer.foregroundColor = UIColor.whiteColor().CGColor
            g.textLayer.contentsScale = UIScreen.mainScreen().scale
            g.textLayer.string = tab.name
            self.layer.addSublayer(g.textLayer)
            
            tabGraphicsItems.append(g)
        }
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.backgroundColor = ColorCanvas
        
        if let ruler = rulerLine {
            ruler.bounds = CGRectMake(0, 0, 0.7 * self.bounds.width, 2)
            ruler.transform = CATransform3DMakeTranslation(self.bounds.width * 0.15, self.bounds.height * 0.4, 0)
        }
        
        if let pct = pctLine {
            pct.bounds = CGRectMake(0, 0, 0.7 * self.bounds.width, 2)
            pct.transform = CATransform3DConcat(
                CATransform3DMakeScale(CGFloat(indicatorIndex) / CGFloat(tabGraphicsItems.count - 1), 1.0, 1.0),
                CATransform3DMakeTranslation(self.bounds.width * 0.15, self.bounds.height * 0.4, 0))
        }
        
        for var i = 0; i < tabGraphicsItems.count; i++ {
            var g = tabGraphicsItems[i]
            var s = circleScale(i)
            var x = (0.15 + 0.7 / CGFloat(tabGraphicsItems.count - 1) * CGFloat(i)) * self.bounds.width
            var y = 0.4 * self.bounds.height
            
            g.iconForeground.transform = CATransform3DConcat(
                CATransform3DMakeScale(s, s, 1),
                CATransform3DMakeTranslation(x, y, 0))
            
            g.textLayer.transform = CATransform3DMakeTranslation(x, 0.8 * self.bounds.height, 0)
        }
    }
    
    func activateTab(index: Int) {
        if index >= 0 && index < tabGraphicsItems.count {
            indicatorIndex = index
            updateIcons()
            setNeedsLayout()
        }
    }
    
    private func updateIcons() {
        for var i = 0; i < tabGraphicsItems.count; i++ {
            var g = tabGraphicsItems[i]
            g.iconForeground.contents = circleContents(i)
            g.iconForeground.backgroundColor = circleColor(i)
        }
    }
    
    private func circleColor(index: Int) -> CGColor {
        if index < indicatorIndex {
            return ColorCompleteTab
        }
        else if index > indicatorIndex {
            return ColorFutureTab
        }
        
        return ColorActiveTab
    }
    
    private func circleContents(index: Int) -> CGImage? {
        if index < indicatorIndex {
            return tabItems[index].imageComplete
        }
        else if index == indicatorIndex {
            return tabItems[index].imageActive
        }
        
        return nil
    }
    
    private func circleScale(index: Int) -> CGFloat {
        if index == indicatorIndex {
            return 1.2
        }
        return 1.0
    }
    
    private func releaseItems() {
        for i in tabGraphicsItems {
            i.iconForeground.removeFromSuperlayer()
            i.textLayer.removeFromSuperlayer()
        }
        
        rulerLine?.removeFromSuperlayer()
        pctLine?.removeFromSuperlayer()
        
        tabItems = nil
        tabGraphicsItems.removeAll(keepCapacity: false)
        rulerLine = nil
        pctLine = nil
        
        indicatorIndex = 0
    }
}
