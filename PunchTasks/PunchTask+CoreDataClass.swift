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
public class PunchTask: NSManagedObject, Identifiable {

    func initRandomMonster() {
        let rand = Double.random(in: 0...1)
        if rand < 0.15 {
            self.eggImage = eggImageList[0...3].randomElement()!
            self.monsterImage = monsterImageList[0...3].randomElement()!
            self.countMax = Int16(Int.random(in: 21...31))
        } else {
            self.eggImage = eggImageList[4...].randomElement()!
            if Double.random(in: 0...1) < 0.5 {
                self.monsterImage = monsterImageList[1...].randomElement()!
                self.countMax = Int16(Int.random(in: 7...31))
            } else {
                self.monsterImage = monsterImageList[4...].randomElement()!
                self.countMax = Int16(Int.random(in: 7...14))
            }
        }

        self.count = 0
        self.isComplete = false
    }
    
}

let eggImageList = [
    "egg_l", "egg_o", "egg_p", "egg_b",
    "egg_d",  "egg_g", "egg_m", "egg_r",
]

let monsterImageList = [
    "poke_pikaqu", "poke_bob1", "poke_bob2", "poke_bob3",
    "poke_minion1", "poke_minion2", "poke_eevee1", "poke_eevee2",
]
