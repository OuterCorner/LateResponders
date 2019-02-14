//
//  OCLateResponderRegistry.m
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "OCLateResponderRegistry.h"
#import "OCInterfaceKit.h"

NSNotificationName const OCLateResponderRegistryDidUpdateNotification = @"OCLateResponderRegistryDidUpdateNotification";

@implementation OCLateResponderRegistry {
    NSMutableArray<OCLateResponder *> *_lateResponders;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lateResponders = [[NSMutableArray alloc] init];
        _initialResponder = [[OCResponder alloc] init];
        _lastResponder = [[OCResponder alloc] init];
        _initialResponder.nextResponder = _lastResponder;
    }
    return self;
}

- (void)registerLateResponder:(OCLateResponder *)responder
{
    if ([_lateResponders containsObject:responder]) { return; }
    
    [responder deregister];
    [_lateResponders addObject:responder];
    responder.registry = self;
    [self updateLateRespondersChain];
}

- (void)deregisterLateResponder:(OCLateResponder *)responder
{
    NSUInteger count = [_lateResponders count];
    [_lateResponders removeObject:responder];
    
    if (count != [_lateResponders count]) {
        // a responder was removed
        responder.registry = nil;
        [self updateLateRespondersChain];
    }
}


#pragma mark - Private

- (void)updateLateRespondersChain
{
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(weight)) ascending:YES];
    [_lateResponders sortUsingDescriptors:@[sd]];
    
    __block InterfaceKitResponder *previousResponder = self.lastResponder;
    [_lateResponders enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(OCLateResponder *responder, NSUInteger idx, BOOL * _Nonnull stop) {
        responder.nextResponder = previousResponder;
        previousResponder = responder;
    }];
    self.initialResponder.nextResponder = previousResponder;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OCLateResponderRegistryDidUpdateNotification object:self];
}

@end
