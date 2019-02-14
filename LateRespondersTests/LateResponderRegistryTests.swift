//
//  LateResponderRegistry.swift
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

import XCTest
import LateResponders

#if os(OSX)
typealias InterfaceKitResponder = NSResponder
extension InterfaceKitResponder {
    var next: NSResponder? {
        return nextResponder
    }
}
#else
typealias InterfaceKitResponder = UIResponder
#endif

func flattenResponderChainStarting(at initialResponder: InterfaceKitResponder) -> [InterfaceKitResponder] {
    
    var responders: [InterfaceKitResponder] = [initialResponder]
    
    guard let nextResponder = initialResponder.next else {
        return responders
    }
    responders.append(contentsOf: flattenResponderChainStarting(at: nextResponder))
    return responders
}

class LateResponderRegistryTests: XCTestCase {


    func testInit() {
        let registry = LateResponderRegistry()
        
        XCTAssertNotNil(registry.initialResponder)
        XCTAssertNotNil(registry.lastResponder)
        
        let responderChain = flattenResponderChainStarting(at: registry.initialResponder)
        
        XCTAssertTrue(responderChain.count == 2)
        XCTAssertEqual(registry.initialResponder, responderChain.first)
        XCTAssertEqual(registry.lastResponder, responderChain.last)
    }

    func testRegistry() {
        
        let registry = LateResponderRegistry()
        let initialResponder = registry.initialResponder
        let lastResponder = registry.lastResponder
        
        
        // register a responder
        let responder1 = LateResponder(weight: 10)
        var notificationExpectation = expectation(forNotification: NSNotification.Name.LateResponderRegistryDidUpdateNotification, object: registry) { (note) -> Bool in
            return registry.isEqual(note.object)
        }
        registry.register(responder1)
        wait(for: [notificationExpectation], timeout: 0.0)
        XCTAssertEqual(flattenResponderChainStarting(at: initialResponder), [initialResponder, responder1, lastResponder])
        
        
        // register a seconde, heavier, responder
        let responder2 = LateResponder(weight: 20)
        notificationExpectation = expectation(forNotification: NSNotification.Name.LateResponderRegistryDidUpdateNotification, object: registry) { (note) -> Bool in
            return registry.isEqual(note.object)
        }
        registry.register(responder2)
        wait(for: [notificationExpectation], timeout: 0.0)
        XCTAssertEqual(flattenResponderChainStarting(at: initialResponder), [initialResponder, responder1, responder2, lastResponder])
        
        // deregister responder1
        notificationExpectation = expectation(forNotification: NSNotification.Name.LateResponderRegistryDidUpdateNotification, object: registry) { (note) -> Bool in
            return registry.isEqual(note.object)
        }
        registry.deregister(responder1)
        wait(for: [notificationExpectation], timeout: 0.0)
        XCTAssertEqual(flattenResponderChainStarting(at: initialResponder), [initialResponder, responder2, lastResponder])
        
        // deregister responder1 again (noop)
        notificationExpectation = expectation(forNotification: NSNotification.Name.LateResponderRegistryDidUpdateNotification, object: registry, handler: nil)
        notificationExpectation.isInverted = true
        registry.deregister(responder1) // should be a no op
        wait(for: [notificationExpectation], timeout: 1.0)
        
        XCTAssertEqual(flattenResponderChainStarting(at: initialResponder), [initialResponder, responder2, lastResponder])
    }
}
