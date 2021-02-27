//
//  IntExtensions.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import Foundation

extension Int{
    //static function -> called from the class name (Int.nextRandom)
    static func nextRandom(upTo max:Int) -> Int{
        var rand:Int = 0
        arc4random_buf(&rand, MemoryLayout<Int>.size)
        rand = abs(rand)
        rand = rand % max
        return rand
    }
}
