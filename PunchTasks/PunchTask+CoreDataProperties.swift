//
//  PunchTask+CoreDataProperties.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/18.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//
//

import Foundation
import CoreData


extension PunchTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PunchTask> {
        return NSFetchRequest<PunchTask>(entityName: "PunchTask")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var eggImage: String?
    @NSManaged public var monsterImage: String?
    
    @NSManaged public var count: Int16
    @NSManaged public var countMax: Int16
    @NSManaged public var isComplete: Bool
    @NSManaged public var update: Date?

}
