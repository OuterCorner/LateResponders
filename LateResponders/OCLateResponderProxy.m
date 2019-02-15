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

#if TARGET_OS_IOS

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL proxyRespondsToSelector = [self.proxiedResponder respondsToSelector:action];
    if (!proxyRespondsToSelector) {
        return NO;
    }
    
    if (self.proxiedSelectorNames != nil && ![self.proxiedSelectorNames containsObject:NSStringFromSelector(action)]) {
        return NO;
    }
    return [self.proxiedResponder canPerformAction:action withSender:sender];
}

#endif

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _proxiedResponder;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature;
    // Keep a strong reference so we can safely send messages
    id object = _proxiedResponder;
    if (object) {
        methodSignature = [object methodSignatureForSelector:aSelector];
    } else {
        // If obj is nil, we need to synthesize a NSMethodSignature. Smallest signature
        // is (self, _cmd) according to the documention for NSMethodSignature.
        NSString *types = [NSString stringWithFormat:@"%s%s", @encode(id), @encode(SEL)];
        methodSignature = [NSMethodSignature signatureWithObjCTypes:[types UTF8String]];
    }
    return methodSignature;
}

// The runtime uses the method signature from above to create an NSInvocation and asks us to
// forward it along as we see fit.
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:_proxiedResponder];
}

#pragma mark - Explicitely forward [NS|UI]Responder methods

- (void)updateUserActivityState:(NSUserActivity *)userActivity
{
    [self.proxiedResponder updateUserActivityState:userActivity];
}

@end
