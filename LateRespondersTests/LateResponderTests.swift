//
//  LateResponderTests.swift
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

import XCTest
import LateResponders


class LateResponderTests: XCTestCase {

    func testDeregister() {
        let registry = LateResponderRegistry()
        
        // register a responder
        let responder = LateResponder(weight: 10)
        XCTAssertNil(responder.registry)
        
        registry.register(responder)
        
        XCTAssertTrue(flattenResponderChainStarting(at: registry.initialResponder).contains(responder))
        XCTAssertNotNil(responder.registry)
        
        responder.deregister()
        XCTAssertFalse(flattenResponderChainStarting(at: registry.initialResponder).contains(responder))
        XCTAssertNil(responder.registry)
    }


}
