//
//  VerticalPages.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation
import UIKit

let SCRUBBLE_CURRENT_BG_IMAGE = UIImage(named: "set")
let SCRUBBLE_CURRENT_BLACK_IMAGE = UIImage(named: "set")
let SCRUBBLE_DOT_IMAGE = UIImage(named: "normal")

private let kScrubbleDotTagBase: Int = 100
private let kScrubbleDotTag: Int = 1000
private let kPageControlWidth: Float = 15
private let kPageControlDotHeight: Float = 30



internal class VerticalPageControl: UIView {
    var numberOfPages: Int = 0
    var currentPage: Int = 0
    
    init(numberOfPages: Int){
        super.init(frame: CGRect(x: 0, y: 0, width: Int(kPageControlWidth), height: Int(kPageControlDotHeight) * numberOfPages))
        setNumberOfPages(numberOfPages: numberOfPages)
        currentPage = 0
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func CreateDot() -> UIView {
        let dot = UIImageView(image: SCRUBBLE_DOT_IMAGE)
        dot.sizeToFit()
        return dot
    }
    
    func CreateCurrentDot() -> UIView {
        let bg = UIImageView(image: SCRUBBLE_CURRENT_BG_IMAGE)
        bg.sizeToFit()
        let black = UIImageView(image: SCRUBBLE_CURRENT_BLACK_IMAGE)
        black.sizeToFit()
        var frame: CGRect = black.frame
        frame.origin.x = (bg.frame.size.width - frame.size.width) / 2.0
        frame.origin.y = ((bg.frame.size.height - frame.size.height) / 2.0) - 1
        black.frame = frame
        bg.addSubview(black)
        return bg
    }
    
    func setCurrentPage(currentPage: Int) {
        if var dot: UIView = self.viewWithTag(kScrubbleDotTagBase + self.currentPage) {
            var currentDot = CreateDot()
            currentDot.center = dot.center
            currentDot.tag = dot.tag
            addSubview(currentDot)
            dot.removeFromSuperview()
            self.currentPage = currentPage
            dot = self.viewWithTag(kScrubbleDotTagBase + self.currentPage)!
            
            currentDot = CreateCurrentDot()
            currentDot.center = dot.center
            currentDot.tag = dot.tag
            addSubview(currentDot)
            dot.removeFromSuperview()
        }
    }
    func setNumberOfPages(numberOfPages: Int) {
        self.numberOfPages = numberOfPages
        for i in 0..<self.numberOfPages {
            let dot = CreateDot()
            dot.tag = kScrubbleDotTagBase + i
            var frame: CGRect? = dot.frame
            frame?.origin.x = (self.frame.size.width - (dot.frame.size.width)) / 2.0
            
            let dotHeight = Int(kPageControlDotHeight)
            let frameH = Int((dot.frame.size.height))
            frame?.origin.y = CGFloat(dotHeight * i + ((dotHeight - frameH) / 2 ))
            dot.frame = frame!
            self.addSubview(dot)
        }
    }
    
}





