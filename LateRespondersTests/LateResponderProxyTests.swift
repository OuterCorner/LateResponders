//
//  LateResponderProxyTests.swift
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

import XCTest
import LateResponders

class MockResponder: InterfaceKitResponder {

    var action1Expectation: XCTestExpectation?
    @objc func action1(_ sender: Any) {
        action1Expectation?.fulfill()
    }
    
    var action2Expectation: XCTestExpectation?
    @objc func action2(_ sender: Any) {
        action2Expectation?.fulfill()
    }
}


class LateResponderProxyTests: XCTestCase {

#if os(OSX)
    func testProxying() {
        let registry = LateResponderRegistry()
        let responder = MockResponder()
        
        let proxy = LateResponderProxy(proxiedResponder: responder)

        registry.register(proxy)
        let initialResponder = registry.initialResponder
        
        // test executing action
        responder.action1Expectation = expectation(description: "Action1 executed")
        var executed = initialResponder.tryToPerform(#selector(MockResponder.action1(_:)), with: nil)
        XCTAssertTrue(executed)
        wait(for: [responder.action1Expectation!], timeout: 0.0)
    
        // test executing non-existent action
        executed = initialResponder.tryToPerform(NSSelectorFromString("action0:"), with: nil)
        XCTAssertFalse(executed)
        
        proxy.proxiedSelectorNames = [NSStringFromSelector(#selector(MockResponder.action2(_:)))]
        
        // test executing filtered actions
        responder.action1Expectation = expectation(description: "Action1 executed")
        responder.action1Expectation?.isInverted = true
        responder.action2Expectation = expectation(description: "Action2 executed")
        
        executed = initialResponder.tryToPerform(#selector(MockResponder.action1(_:)), with: nil)
        XCTAssertFalse(executed)
        
        executed = initialResponder.tryToPerform(#selector(MockResponder.action2(_:)), with: nil)
        XCTAssertTrue(executed)
        
        wait(for: [responder.action1Expectation!, responder.action2Expectation!], timeout: 0.0)
    }
#elseif os(iOS)
    func testProxying() {
        let registry = LateResponderRegistry()
        let responder = MockResponder()
        
        let proxy = LateResponderProxy(proxiedResponder: responder)
        
        registry.register(proxy)
        let initialResponder = registry.initialResponder
        let action1 = #selector(MockResponder.action1(_:))
        let action2 = #selector(MockResponder.action2(_:))
        let action0 = NSSelectorFromString("action0:")
        
        // test executing action
        responder.action1Expectation = expectation(description: "Action1 executed")
        (initialResponder.target(forAction: action1, withSender: nil) as? UIResponder)?.perform(action1, with: nil)
        wait(for: [responder.action1Expectation!], timeout: 0.0)

        // test executing non-existent action
        XCTAssertNil(initialResponder.target(forAction: action0, withSender: nil))

        proxy.proxiedSelectorNames = [NSStringFromSelector(action2)]
        
        // test executing filtered actions
        responder.action1Expectation = expectation(description: "Action1 executed")
        responder.action1Expectation?.isInverted = true
        responder.action2Expectation = expectation(description: "Action2 executed")

        XCTAssertNil(initialResponder.target(forAction: action1, withSender: nil))
        (initialResponder.target(forAction: action2, withSender: nil) as? UIResponder)?.perform(action2, with: nil)
        wait(for: [responder.action1Expectation!, responder.action2Expectation!], timeout: 0.0)
    }
#endif
}
