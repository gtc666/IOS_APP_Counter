//
//  CounterViewControler.swift
//  swiftcounter
//
//  Created by 陈珊涛 on 15/7/23.
//  Copyright © 2015年 顾天聪. All rights reserved.
//

import Foundation
import UIKit

class CounterViewController : UIViewController {
    
    //UIcontrollers
    var timeLabel : UILabel? //显示剩余时间
    var timeButtons : [UIButton]? //设置时间的按钮数组
    var startstopButton : UIButton? //启动/停止按键
    var clearButton : UIButton? //复位按钮
    
    let timeButtoninfos = [("1 min",60),("3 min",180),("5min",300),("1 sec",1)] //不同按钮信息
    
    var remainingseconds : Int = 0 {
        willSet(newseconds){
            
            let mins = newseconds/60
            let secs = newseconds%60
            if (secs >= 0) {
               timeLabel!.text  = NSString(format: "%02d:%02d", mins, secs) as String
            }
            
        }
        
    }
    
    var isCounting = false{
    
        willSet(newValue){
        
            if newValue {
            
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil , repeats: true)
            }
            else {
            
                timer?.invalidate()
                timer = nil
            }
            setSettingButtonsEnabled(!newValue)
        }
    }
    
    var timer : NSTimer?
    
    
    //UI Helpers
    func setuptimeLabel () {
        timeLabel = UILabel()
        timeLabel!.textColor = UIColor.whiteColor()
        timeLabel!.font = UIFont(name: "gtc", size: 80)
        timeLabel!.backgroundColor = UIColor.blackColor()
        timeLabel!.textAlignment = NSTextAlignment.Center
        timeLabel!.text = ("00:00")
        //倒计时剩余时间的标签
        self.view.addSubview(timeLabel!) //将timeLabele添加到控制器对应的view上
    }
    
    func setuptimeButtons () {
        var buttons: [UIButton] = []
        var t = 0
    
        //for (index,(title,_)) in enumerate(timeButtoninfos) {
        for title in timeButtoninfos {
            let button : UIButton = UIButton()
            //button.tag = index //保存按钮的index
            button.setTitle("\(title.0)", forState: UIControlState.Normal)
            button.tag = t
            button.backgroundColor = UIColor.orangeColor()
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            buttons.append(button) //方便日后调用
            self.view.addSubview(button)
            t++
        }
        timeButtons = buttons
    }
    
    func setupactionButtons() {
        //create start/stop button
        
        startstopButton = UIButton()
        startstopButton!.backgroundColor = UIColor.redColor()
        startstopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startstopButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startstopButton!.setTitle("启动/停止", forState: UIControlState.Normal)
        startstopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startstopButton!)
        
        
        clearButton = UIButton()
        clearButton!.backgroundColor = UIColor.redColor()
        clearButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton!.setTitle("复位", forState: UIControlState.Normal)
        clearButton!.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(clearButton!)
    }
    
        //actions & callbacks
        
    func startStopButtonTapped(sender: UIButton){
        isCounting = !isCounting
    }
    func clearButtonTapped(sender: UIButton){
        remainingseconds = 0
    }
    func timeButtonTapped(sender: UIButton){
        let (_,seconds) = timeButtoninfos[sender.tag]
        remainingseconds += seconds
    }
    func updateTimer(timer: NSTimer){
        remainingseconds -= 1
        
        if remainingseconds == 0 {
            let alert = UIAlertController()
            alert.title  = "计时完成"
            alert.message = ""
            //alert.addButtonWithTitle("OK")
            //alert.show()
            let action = UIAlertAction(title: "OK", style: .Default){ _ in
                
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            isCounting = !isCounting
        }
    }
    func setSettingButtonsEnabled(enabled : Bool){
        for button in timeButtons! {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 :0.3
        }
        clearButton!.enabled = enabled
        clearButton!.alpha = enabled ? 1.0 :0.3
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        setuptimeLabel()
        setuptimeButtons()
        setupactionButtons()
    }//主要用来创建和初始化UI
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLabel!.frame = CGRectMake(10, 40, self.view.bounds.size.width-20, 120)
        let gap = ( self.view.bounds.size.width - 2*10 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count-1)
        var i = 0
        for button in timeButtons!{
            let buttonleft = 10 + (64+gap) * CGFloat(i)
            button.frame = CGRectMake(buttonleft, self.view.bounds.size.height-120, 64, 44)
            i++
        }
        
        startstopButton!.frame = CGRectMake(10, self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44)
        clearButton!.frame = CGRectMake(10+self.view.bounds.size.width-20-100+20, self.view.bounds.size.height-60, 80, 44)
    }
    
    
    
}