//
//  OCLateResponderProxy.m
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "OCLateResponderProxy.h"

@implementation OCLateResponderProxy

+ (instancetype)proxyForResponder:(InterfaceKitResponder *)responder
{
    return [[[self class] alloc] initWithProxiedResponder:responder];
}

- (instancetype)initWithProxiedResponder:(InterfaceKitResponder *)responder
{
    return [self initWithProxiedResponder:responder weight:0];
}

- (instancetype)initWithProxiedResponder:(InterfaceKitResponder *)responder weight:(NSInteger)weight
{
    self = [super initWithWeight:weight];
    if (self) {
        _proxiedResponder = responder;
    }
    return self;
}

- (instancetype)initWithWeight:(NSInteger)weight
{
    return  [self initWithProxiedResponder:[InterfaceKitResponder new] weight:weight];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL ourSuperclassRespondsToSelector = [OCLateResponder instancesRespondToSelector:aSelector];
    if (ourSuperclassRespondsToSelector) {
        return YES;
    }
    
    BOOL proxyRespondsToSelector = [self.proxiedResponder respondsToSelector:aSelector];
    
    if (self.proxiedSelectorNames != nil) {
        return proxyRespondsToSelector && [self.proxiedSelectorNames containsObject:NSStringFromSelector(aSelector)];
    }
    
    return proxyRespondsToSelector;
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _proxiedResponder;
}


#pragma mark - Explicitely forward [NS|UI]Responder methods

- (void)updateUserActivityState:(NSUserActivity *)userActivity
{
    [self.proxiedResponder updateUserActivityState:userActivity];
}

@end
