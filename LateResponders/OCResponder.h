//
//  OCResponder.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "InterfaceKit.h"
#import "Macros.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Responder)
@interface OCResponder : InterfaceKitResponder

#if TARGET_OS_IOS
- (void)setNextResponder:(InterfaceKitResponder * __nullable)nextResponder;
#endif

@end

NS_ASSUME_NONNULL_END
