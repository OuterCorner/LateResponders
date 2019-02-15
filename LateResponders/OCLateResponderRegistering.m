//
//  OCLateResponderRegistering.m
//  LateResponders
//
// Created by Paulo Andrade on 15/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "OCLateResponderRegistering.h"


@implementation  InterfaceKitViewController (OCLateResponderRegistering)

- (InterfaceKitViewController<OCLateResponderRegistering> *)lateResponderRegisteringViewController
{
    InterfaceKitViewController *c = self;
    while (c != nil && ![c conformsToProtocol:@protocol(OCLateResponderRegistering)]) {
        c = [c parentViewController];
    }
    return (InterfaceKitViewController<OCLateResponderRegistering>*) c;
}


@end
