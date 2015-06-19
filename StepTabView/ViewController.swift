//
//  ViewController.swift
//  MakeSomeAnimations
//
//  Created by Liu Yang on 6/17/15.
//  Copyright (c) 2015 Liu Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tabView: StepTabView!
    
    private var tabs: [StepTabItem]!
    private var imageCheckmark: UIImage!
    private var imageIndicator: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageCheckmark = UIImage(named: "checkmark")
        imageIndicator = UIImage(named: "indicator")
        
        tabs = ["Welcome", "Readme", "Setup"].map { (name: String) -> StepTabItem in
            var item = StepTabItem()
            item.name = name
            item.imageActive = self.imageIndicator
            item.imageComplete = self.imageCheckmark
            return item
        }
        
        tabView.initTabs(tabs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prevClicked(sender: AnyObject) {
        tabView.activateTab(tabView.indicatorIndex - 1)
    }
    
    @IBAction func nextClicked(sender: AnyObject) {
        tabView.activateTab(tabView.indicatorIndex + 1)
    }
    
    @IBOutlet weak var extraName: UITextField!
    
    @IBAction func moreClicked(sender: AnyObject) {
        var item = StepTabItem()
        item.name = extraName.text
        item.imageActive = imageIndicator
        item.imageComplete = imageCheckmark
        tabs.append(item)
        tabView.initTabs(tabs)
    }
    
    @IBAction func lessClicked(sender: AnyObject) {
        if !tabs.isEmpty {
            tabs.removeLast()
            tabView.initTabs(tabs)
        }
    }
}

