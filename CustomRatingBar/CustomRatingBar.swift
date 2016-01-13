//
//  CustomRatingBar.swift
//  CustomRatingBar
//
//  Created by 陈磊 on 16/1/11.
//  Copyright © 2016年 ShenSu. All rights reserved.
//

import UIKit

protocol CustomRatingBarDelegate {
    func ratingDidChange(ratingBar: CustomRatingBar,rating: CGFloat)
}

/// 星级评分控件
class CustomRatingBar: UIView {
    
    var delegate: CustomRatingBarDelegate?
    @IBInspectable var ratingMax:CGFloat = 10//总分
    @IBInspectable var starNums:Int = 5//星星总数
    /// 分数
    @IBInspectable var rating:CGFloat = 0{
        didSet{
            if 0 > rating {rating = 0}
            else if ratingMax < rating {rating = ratingMax}
            //回调给代理
            delegate?.ratingDidChange(self, rating: rating)
            self.setNeedsLayout()
        }
    }
    @IBInspectable var imageLight:UIImage = UIImage(named: "ratingbar_star_light")!
    @IBInspectable var imageDark:UIImage = UIImage(named: "ratingbar_star_dark")!
    var foregroundRatingView: UIView!
    var backgroundRatingView: UIView!
    @IBInspectable var canAnimation: Bool = false//是否开启动画模式
    @IBInspectable var animationTimeInterval: NSTimeInterval = 0.2//动画时间
    @IBInspectable var isIndicator:Bool = false//是否是一个指示器（用户无法进行更改）
    
    var isDrew = false//是否创建过
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.buildView()
        let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
        //开启动画改变foregroundRatingView可见范围
        UIView.animateWithDuration(animationTimeInterval, animations: {self.animationRatingChange()})
    }
    
    /**
     根据图片名，创建一列RatingBar
     
     - parameter image: 图片
     
     - returns: view
     */
    func createRatingView(image: UIImage) ->UIView{
        let view = UIView(frame: self.bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearColor()
        //开始创建子Item,根据starNums总数
        for position in 0 ..< starNums{
            let imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(CGFloat(position) * self.bounds.size.width / CGFloat(starNums), 0, self.bounds.size.width / CGFloat(starNums), self.bounds.size.height)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            view.addSubview(imageView)
        }
        return view
    }
    
    /**
     创建CustomRatingBar
     */
    func buildView(){
        if isDrew {
            return
        }
        isDrew = true
        //创建前后两个View，作用是通过rating数值显示或者隐藏“foregroundRatingView”来改变RatingBar的星星效果
        self.backgroundRatingView = self.createRatingView(imageDark)
        self.foregroundRatingView = self.createRatingView(imageLight)
        animationRatingChange()
        self.addSubview(self.backgroundRatingView)
        self.addSubview(self.foregroundRatingView)
        //加入单击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapRateView:")
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    /**
     改变foregroundRatingView可见范围
     */
    func animationRatingChange(){
        let realRatingScore = self.rating / self.ratingMax
        self.foregroundRatingView.frame = CGRectMake(0, 0,self.bounds.size.width * realRatingScore, self.bounds.size.height)
        
    }
    
    /**
     点击编辑分数后，通过手势的x坐标来设置数值
     
     - parameter sender: 点击手势
     */
    func tapRateView(sender: UITapGestureRecognizer){
        if isIndicator {return}//如果是指示器，就不能交互
        let tapPoint = sender.locationInView(self)
        let offset = tapPoint.x
        //通过x坐标判断分数
        let realRatingScore = offset / (self.bounds.size.width / self.ratingMax);
        self.rating = round(realRatingScore)
    }
    
    
    
}
