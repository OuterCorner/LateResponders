//
//  OCLateResponder.m
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "OCLateResponder.h"
#import "OCLateResponderRegistry.h"

@implementation OCLateResponder {
    NSArray *_keyCommands;
}

- (instancetype)init
{
    self = [self initWithWeight:0];
    return self;
}

- (instancetype)initWithWeight:(NSInteger)weight
{
    self = [super init];
    if (self) {
        _weight = weight;
    }
    return self;
}

- (void)deregister
{
    [self.registry deregisterLateResponder:self];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self initWithWeight:0];
    return self;
}

#if TARGET_OS_IOS
- (NSArray<UIKeyCommand *> *)keyCommands
{
    if (self.keyCommandsBlock) {
        return self.keyCommandsBlock();
    }
    return _keyCommands;
}

- (void)setKeyCommands:(NSArray<UIKeyCommand *> *)keyCommands
{
    self.keyCommandsBlock = nil;
    _keyCommands = keyCommands;
}

#endif

@end
