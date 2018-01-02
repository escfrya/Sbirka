//
//  SbirkaTests.swift
//  SbirkaTests
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import XCTest
@testable import Sbirka

class SbirkaTests: XCTestCase {
    private var testVC: TestViewController!
    private let item1 = TextCellViewModel(text: NSAttributedString(), id: "1")
    private let item2 = TextCellViewModel(text: NSAttributedString(), id: "2")
    private let item3 = TextCellViewModel(text: NSAttributedString(), id: "3")
    
    override func setUp() {
        super.setUp()
        
        testVC = TestViewController()
        UIApplication.shared.keyWindow?.rootViewController = testVC
        _ = testVC.view
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testInsertCell() {
        setup(beforeItems: [[item1, item2]], afterItems: [[item1, item2, item3]]) {
            self.asserSections(count: 1)
            self.assertCells(count: 3, inSection: 0)
        }
    }
    
    func testDeleteCell() {
        setup(beforeItems: [[item1, item2, item3]], afterItems: [[item1, item2]]) {
            self.asserSections(count: 1)
            self.assertCells(count: 2, inSection: 0)
        }
    }
    
    func testMoveCell() {
        setup(beforeItems: [[item1, item2, item3]], afterItems: [[item1, item3, item2]]) {
            self.asserSections(count: 1)
            self.assertCells(count: 3, inSection: 0)
            self.itemWith(id: "1", atSection: 0, row: 0)
            self.itemWith(id: "3", atSection: 0, row: 1)
            self.itemWith(id: "2", atSection: 0, row: 2)
        }
    }
    
    func testInsertSection() {
        setup(beforeItems: [[item1]], afterItems: [[item1], [item2]]) {
            self.asserSections(count: 2)
            self.assertCells(count: 1, inSection: 0)
            self.assertCells(count: 1, inSection: 1)
        }
    }
    
    func testDeleteSection() {
        setup(beforeItems: [[item1], [item2]], afterItems: [[item1]]) {
            self.asserSections(count: 1)
            self.assertCells(count: 1, inSection: 0)
            self.itemWith(id: "1", atSection: 0, row: 0)
        }
    }
    
    func testMoveSection() {
        setup(beforeItems: [[item1], [item2], [item3]], afterItems: [[item1], [item3], [item2]]) {
            self.asserSections(count: 3)
            self.itemWith(id: "1", atSection: 0, row: 0)
            self.itemWith(id: "3", atSection: 1, row: 0)
            self.itemWith(id: "2", atSection: 2, row: 0)
        }
    }
    
    func testMoveCellFromDeletedSection() {
        setup(beforeItems: [[item1], [item2]], afterItems: [[item1, item2]]) {
            self.asserSections(count: 1)
            self.assertCells(count: 2, inSection: 0)
            self.itemWith(id: "1", atSection: 0, row: 0)
            self.itemWith(id: "2", atSection: 0, row: 1)
        }
    }
    
    private func setup(desc: String = "", beforeItems: [[BaseCellViewModel]], afterItems: [[BaseCellViewModel]], callback: @escaping () -> Void) {
        let exp = expectation(description: desc)
        
        testVC.sbirkaView.update(items: beforeItems, context: .firstLoad) {
            self.testVC.sbirkaView.update(items: afterItems, context: .normal) {
                exp.fulfill()
                callback()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func asserSections(count: Int) {
        XCTAssert(testVC.sbirkaView.numberOfSections == count)
    }
    
    private func assertCells(count: Int, inSection section: Int) {
        XCTAssert(testVC.sbirkaView.numberOfItems(inSection: section) == count)
    }
    
    private func itemWith(id: String, atSection section: Int, row: Int) {
        if let (indexPath, _) = testVC.sbirkaView.getViewModelById(TextCellViewModel.self, id) {
            XCTAssert(indexPath.item == row && indexPath.section == section)
        } else {
            XCTAssertTrue(false, "can't find item with id = \(id)")
        }
    }
}
