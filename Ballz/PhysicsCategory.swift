//
//  PhysicsCategory.swift
//  Ballz
//
//  Created by Alan Gao on 7/6/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:        UInt32 = 0b0    //0000
    static let Ball:        UInt32 = 0b1    //0001
    static let Funnel:      UInt32 = 0b10   //0010
    static let InnerCircle: UInt32 = 0b100  //0100
    static let boundary:    UInt32 = 0b1000 //1000
}