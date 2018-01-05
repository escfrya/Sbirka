//
//  CollectionChanges.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation

struct CollectionChangeMove: Equatable, Hashable {
    let indexPathOld: IndexPath
    let indexPathNew: IndexPath
    init(indexPathOld: IndexPath, indexPathNew: IndexPath) {
        self.indexPathOld = indexPathOld
        self.indexPathNew = indexPathNew
    }
    
    var hashValue: Int { return (indexPathOld as NSIndexPath).hash ^ (indexPathNew as NSIndexPath).hash }
}

func == (lhs: CollectionChangeMove, rhs: CollectionChangeMove) -> Bool {
    return lhs.indexPathOld == rhs.indexPathOld && lhs.indexPathNew == rhs.indexPathNew
}

struct CollectionChanges {
    let insertedIndexPaths: Set<IndexPath>
    let deletedIndexPaths: Set<IndexPath>
    let movedIndexPaths: [CollectionChangeMove]
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    
    init(insertedIndexPaths: Set<IndexPath>, deletedIndexPaths: Set<IndexPath>, movedIndexPaths: [CollectionChangeMove], insertedSections: IndexSet, deletedSections: IndexSet) {
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
        self.movedIndexPaths = movedIndexPaths
        self.insertedSections = insertedSections
        self.deletedSections = deletedSections
    }
    
    static var empty: CollectionChanges {
        return CollectionChanges(insertedIndexPaths: [], deletedIndexPaths: [], movedIndexPaths: [], insertedSections: IndexSet(), deletedSections: IndexSet())
    }
}

func generateChanges(oldCollection: [[BaseCellViewModel]], newCollection: [[BaseCellViewModel]]) -> CollectionChanges {
    func generateIndexesById(_ collection: [[BaseCellViewModel]]) -> [String: IndexPath] {
        var map = [String: IndexPath](minimumCapacity: collection.count)
        for (sectionIndex, section) in collection.enumerated() {
            for (itemIndex, item) in section.enumerated() {
                map[String(item.id)] = IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
        return map
    }

    let oldIndexsById = generateIndexesById(oldCollection)
    let newIndexsById = generateIndexesById(newCollection)
    
    var deletedIndexPaths = Set<IndexPath>()
    var insertedIndexPaths = Set<IndexPath>()
    var movedIndexPaths = [CollectionChangeMove]()
    var insertedSections = IndexSet()
    var deletedSections = IndexSet()
    
    // Sync sections
    if newCollection.count != oldCollection.count {
        let oldIndexSet = IndexSet.init(integersIn: 0..<oldCollection.count)
        let newIndexSet = IndexSet.init(integersIn: 0..<newCollection.count)
        insertedSections = newIndexSet.subtracting(oldIndexSet)
        deletedSections = oldIndexSet.subtracting(newIndexSet)
    }
    
    // Deletetions
    for oldSection in oldCollection {
        for old in oldSection {
            let oldId = String(old.id)
            let isDeleted = newIndexsById[oldId] == nil //&& newOldIndexesById[oldId] == nil
            if isDeleted {
                let oldIndexPath = oldIndexsById[oldId]!
                deletedIndexPaths.insert(oldIndexPath)
            }
        }
    }
    
    // Insertions and movements
    for newSection in newCollection {
        for new in newSection {
            let newId = String(new.id)
            let newIndexPath = newIndexsById[newId]!
            if let oldIndexPath = oldIndexsById[newId] {
                if oldIndexPath.item != newIndexPath.item ||
                    oldIndexPath.section != newIndexPath.section {
                    if deletedSections.contains(oldIndexPath.section) {
                        deletedIndexPaths.insert(oldIndexPath)
                        insertedIndexPaths.insert(newIndexPath)
                    } else {
                        movedIndexPaths.append(CollectionChangeMove(indexPathOld: oldIndexPath, indexPathNew: newIndexPath))
                    }
                }
            } else {
                // It's new
                insertedIndexPaths.insert(newIndexPath)
            }
        }
    }
    
    return CollectionChanges(insertedIndexPaths: insertedIndexPaths, deletedIndexPaths: deletedIndexPaths, movedIndexPaths: movedIndexPaths, insertedSections: insertedSections, deletedSections: deletedSections)
}
