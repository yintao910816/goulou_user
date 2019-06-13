//
//  Timer.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

class CountdownTimer {

    private var timer: Timer!
    private var totleCount: Int!
    
    private var cutdown: Int!
    
    public var showTextCallBack: ((Int) ->())?

    init(timeInterval interval: Int = 1, totleCount count: Int = 60) {
        
        self.totleCount = count
        cutdown = count
        
        if #available(iOS 10.0, *) {
            timer = Timer.init(fire: Date.distantFuture,
                               interval: TimeInterval(interval),
                               repeats: true,
                               block: { [unowned self] timer in
                                self.cutdownInterval()
                               })
        } else {
            timer = Timer.init(fireAt: Date.distantFuture,
                               interval: TimeInterval(interval),
                               target: self,
                               selector: #selector(timerCutdown),
                               userInfo: nil,
                               repeats: true)
            timer.fireDate = Date.distantFuture
        }
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
        
    }
    
    @objc private func timerCutdown() {
        self.cutdownInterval()
    }
    
    private func cutdownInterval() {

        if cutdown > 0 {
            cutdown = cutdown - 1
            showTextCallBack?(cutdown)
        }else {
            timer.fireDate = Date.distantFuture
            cutdown = totleCount
        }
    }
    
    //MARK:
    //MARK: public
    public final func timerPause() {
        timer.fireDate = Date.distantFuture
        cutdown = totleCount
    }

    public final func timerStar() {
        if timer != nil { timer.fireDate = Date() }
    }

    public final func timerRemove() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    deinit {
        timerRemove()
        HCPrint(message: "计时器释放了")
    }

}
