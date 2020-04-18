//
//  PunchTask+CoreDataClass.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/18.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//
//

import Foundation
import CoreData

@objc(PunchTask)
public class PunchTask: NSManagedObject {
    
    func initRandomMonster() {
        self.eggImage = eggImageList.randomElement()!
        self.monsterImage = "empty"
        
        self.count = 0
        self.countMax = Int16(Int.random(in: 8...31))
        self.isComplete = false
        self.update = Date()
    }
    
}

let eggImageList = [
    "egg_b",  "egg_d",  "egg_g",
    "egg_l",  "egg_m",  "egg_o",
    "egg_p",  "egg_r",
]
