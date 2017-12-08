/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import WCDB

class RowSelectTests: CRUDTestCase {
    
    var rowSelect: RowSelect!
    
    override func setUp() {
        super.setUp()
        
        let optionalRowSelect = WCDBAssertNoThrowReturned(try database.prepareRowSelect(fromTable: CRUDObject.name), whenFailed: nil)
        XCTAssertNotNil(optionalRowSelect)
        rowSelect = optionalRowSelect!
    }

    func testRowSelect() {
        //When
        let results: FundamentalRowXColumn = WCDBAssertNoThrowReturned(try rowSelect.allRows())
        //Then
        XCTAssertEqual(results.count, preInsertedObjects.count)
        XCTAssertEqual(Int(results[row: 0, column: 0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(results[row: 0, column: 1].stringValue, preInsertedObjects[0].variable2)
        XCTAssertEqual(Int(results[row: 1, column: 0].int64Value), preInsertedObjects[1].variable1)
        XCTAssertEqual(results[row: 1, column: 1].stringValue, preInsertedObjects[1].variable2)
    }
    
    func testConditionalRowSelect() {
        //When
        let results: FundamentalRowXColumn = WCDBAssertNoThrowReturned(try rowSelect.where(CRUDObject.CodingKeys.variable1 == 1).allRows())
        //Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(Int(results[row: 0, column: 0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(results[row: 0, column: 1].stringValue, preInsertedObjects[0].variable2)
    }
    
    func testOrderedRowSelect() {
        //Give
        let order = (CRUDObject.CodingKeys.variable1).asOrder(by: .Descending)
        //When
        let results: FundamentalRowXColumn = WCDBAssertNoThrowReturned(try rowSelect.order(by: order).allRows())
        //Then
        XCTAssertEqual(results.count, preInsertedObjects.count)
        XCTAssertEqual(Int(results[row: 0, column: 0].int64Value), preInsertedObjects[1].variable1)
        XCTAssertEqual(results[row: 0, column: 1].stringValue, preInsertedObjects[1].variable2)
        XCTAssertEqual(Int(results[row: 1, column: 0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(results[row: 1, column: 1].stringValue, preInsertedObjects[0].variable2)
    }
    
    func testLimitedRowSelect() {
        //When
        let results: FundamentalRowXColumn = WCDBAssertNoThrowReturned(try rowSelect.limit(1).allRows())
        //Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(Int(results[row: 0, column: 0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(results[row: 0, column: 1].stringValue, preInsertedObjects[0].variable2)
    }
    
    func testOffsetRowSelect() {
        //When
        let results: FundamentalRowXColumn = WCDBAssertNoThrowReturned(try rowSelect.limit(1, offset: 1).allRows())
        //Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(Int(results[row: 0, column: 0].int64Value), preInsertedObjects[1].variable1)
        XCTAssertEqual(results[row: 0, column: 1].stringValue, preInsertedObjects[1].variable2)
    }
    
    func testHalfRowSelect() {
        //Give
        let optionalRowSelect = WCDBAssertNoThrowReturned(try database.prepareRowSelect(on: CRUDObject.CodingKeys.variable2, fromTable: CRUDObject.name), whenFailed: nil)
        XCTAssertNotNil(optionalRowSelect)
        rowSelect = optionalRowSelect!
        //When
        let results: FundamentalRowXColumn = WCDBAssertNoThrowReturned(try rowSelect.allRows())
        //Then
        XCTAssertEqual(results.count, preInsertedObjects.count)
        XCTAssertEqual(results[row: 0, column: 0].stringValue, preInsertedObjects[0].variable2)
        XCTAssertEqual(results[row: 1, column: 0].stringValue, preInsertedObjects[1].variable2)
    }
    
    func testRowSelectIteration() {
        //When
        var results: FundamentalRowXColumn = []
        while let result = WCDBAssertNoThrowReturned(try rowSelect.nextRow(), whenFailed: nil) {
            results.append(result)
        }
        //Then
        XCTAssertEqual(results.count, preInsertedObjects.count)
        XCTAssertEqual(Int(results[row: 0, column: 0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(results[row: 0, column: 1].stringValue, preInsertedObjects[0].variable2)
        XCTAssertEqual(Int(results[row: 1, column: 0].int64Value), preInsertedObjects[1].variable1)
        XCTAssertEqual(results[row: 1, column: 1].stringValue, preInsertedObjects[1].variable2)
    }

    func testRowSelectValue() {
        //When
        let results: FundamentalColumn = WCDBAssertNoThrowReturned(try rowSelect.allValues())
        //Then
        XCTAssertEqual(results.count, preInsertedObjects.count)
        XCTAssertEqual(Int(results[0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(Int(results[1].int64Value), preInsertedObjects[1].variable1)
    }

    func testRowSelectValueIteraion() {
        //When
        var results: FundamentalColumn = []
        while let result = WCDBAssertNoThrowReturned(try rowSelect.nextValue(), whenFailed: nil) {
            results.append(result)
        }
        //Then
        XCTAssertEqual(results.count, preInsertedObjects.count)
        XCTAssertEqual(Int(results[0].int64Value), preInsertedObjects[0].variable1)
        XCTAssertEqual(Int(results[1].int64Value), preInsertedObjects[1].variable1)
    }

}