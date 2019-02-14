//
//  OCLateResponderProxy.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import <LateResponders/OCLateResponder.h>
#import <LateResponders/Macros.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A subclass of OCLateResponder that proxies a given responder.
 */
NS_SWIFT_NAME(LateResponderProxy)
@interface OCLateResponderProxy : OCLateResponder

+ (instancetype)proxyForResponder:(InterfaceKitResponder *)responder;

- (instancetype)initWithProxiedResponder:(InterfaceKitResponder *)responder;
- (instancetype)initWithProxiedResponder:(InterfaceKitResponder *)responder weight:(NSInteger)weight NS_DESIGNATED_INITIALIZER; 

@property (nonatomic, weak, readonly) InterfaceKitResponder *proxiedResponder;

/** If this property is set, then only the specified selectors are proxied. */
@property (nullable, nonatomic, strong) NSArray<NSString *> *proxiedSelectorNames;

@end

NS_ASSUME_NONNULL_END
