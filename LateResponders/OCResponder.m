//
//  OCResponder.m
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "OCResponder.h"

@implementation OCResponder {
    __weak InterfaceKitResponder *_nextResponder;
}


#if TARGET_OS_IOS
- (InterfaceKitResponder *)nextResponder
{
    return _nextResponder;
}

- (void)setNextResponder:(InterfaceKitResponder * __nullable)nextResponder
{
    _nextResponder = nextResponder;
}
#endif

@end
