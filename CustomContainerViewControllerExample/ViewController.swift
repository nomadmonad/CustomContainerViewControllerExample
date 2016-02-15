//
//  ViewController.swift
//  CustomContainerViewControllerExample
//
//  Created by tyamamo on 2016/02/15.
//  Copyright © 2016年 local. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        let delay = 2.0
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_MSEC)))
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        dispatch_after(time, dispatch_get_main_queue(), {() -> Void in
            let vc = sb.instantiateViewControllerWithIdentifier("OtherViewController") as! OtherViewController
            vc.view.backgroundColor = UIColor.redColor()
            vc.textLabel.text = "redVC"
            self.displayContentController(vc)
            let transitionTime =  dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_MSEC)))
            dispatch_after(transitionTime, dispatch_get_main_queue(), {() -> Void in
                let newVC = sb.instantiateViewControllerWithIdentifier("OtherViewController") as! OtherViewController
                newVC.view.backgroundColor = UIColor.greenColor()
                newVC.textLabel.text = "GreenVC"
                self.cycleViewControllers(vc, toViewController: newVC)
            })
        })
    }
    
    func displayContentController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = self.view.bounds
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }

    func hideContentController(content: UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }

    func cycleViewControllers(fromViewController: UIViewController, toViewController: UIViewController) {
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)

        let width = view.bounds.size.width
        let height = view.bounds.size.height
        let startFrame = CGRectMake(0, height, width, height)
        toViewController.view.frame = startFrame
        let endFrame = CGRectMake(0, 100, width, height)
        self.transitionFromViewController(fromViewController,
            toViewController: toViewController,
            duration: 0.25,
            options: .TransitionNone,
            animations: {
                toViewController.view.frame = fromViewController.view.frame
                fromViewController.view.frame = endFrame
            },
            completion: {_ in
                self.hideContentController(fromViewController)
                toViewController.didMoveToParentViewController(self)
            })
    }
    
}

