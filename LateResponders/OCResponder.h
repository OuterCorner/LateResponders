//
//  OCResponder.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "OCInterfaceKit.h"
#import "OCMacros.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Responder)
@interface OCResponder : InterfaceKitResponder

#if TARGET_OS_IOS
- (void)setNextResponder:(InterfaceKitResponder * __nullable)nextResponder;

// Apparently there are cases in AppKit where the nextResponder ivar is accessed directly, bypassing the getter so we're not offering this feature on macOS yet
@property (nonatomic, copy) InterfaceKitResponder *__nullable (^nextResponderBlock)(void);

#endif



@end

NS_ASSUME_NONNULL_END
