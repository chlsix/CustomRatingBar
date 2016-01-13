//
//  ViewController.swift
//  CustomRatingBar
//
//  Created by 陈磊 on 16/1/11.
//  Copyright © 2016年 ShenSu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomRatingBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let customRatingBar = CustomRatingBar(frame: CGRectMake(40, 100, 200, 40))
        customRatingBar.rating = 5
        customRatingBar.delegate = self
        self.view.addSubview(customRatingBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func ratingDidChange(ratingBar: CustomRatingBar, rating: CGFloat) {
        print(rating)
    }

}

