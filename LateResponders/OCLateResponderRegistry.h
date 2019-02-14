//
//  OCLateResponderRegistry.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCResponder.h"
#import "OCLateResponder.h"


NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LateResponderRegistryDidUpdateNotification)
extern NSNotificationName const OCLateResponderRegistryDidUpdateNotification; /** sent when the late responder chain changes */


/**
 The late responder registry.
 This class maintains an order list of late responders -- the late responder chain -- sorted by their weight.
 
 Clients will usually hook the late responder chain somewhere in their app's regular responder chain as after  NSWindow/UIWindow or some view controller.
 
 For example, to hook this chain after the a window, a client would set nextResponder of their window (on iOS this requires subclassing) to the initialResponder,
 and set the nextResponder of lastResponder to whatever was the nextResponder of the window previously.
 */
NS_SWIFT_NAME(LateResponderRegistry)
@interface OCLateResponderRegistry : NSObject


/**
 The entry point for the "late responder chain".
 You should patch your responder chain by setting the nextResponder of some responder on your chain to this property.
 */
@property (nonatomic, strong, readonly) OCResponder *initialResponder;

/**
 The exit point for the "late responder chain".
 You should set the nextResponder of this property to a responder on your chain.
 */
@property (nonatomic, strong, readonly) OCResponder *lastResponder;


/**
 Registers a late responder.
 
 The responder is inserted in the chain based on its weight property.
 @param responder the responder to add to the chain
 */
- (void)registerLateResponder:(OCLateResponder *)responder;

/**
 Removes a late responder from the chain.
 
 @param responder the responder to remove
 */
- (void)deregisterLateResponder:(OCLateResponder *)responder;

@end

NS_ASSUME_NONNULL_END
