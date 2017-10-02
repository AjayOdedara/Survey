//
//  SubView.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation
import UIKit


internal class SubView: UIView {
    
    var scrollView = UIScrollView()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let child: UIView? = nil
        let test = super.hitTest(point, with: event)
        if test == self{
            return scrollView
        }
        return child
    }

}

