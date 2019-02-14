//
//  OCLateResponder.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LateResponders/OCResponder.h>

@class OCLateResponderRegistry;

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a late responder.
 You should subclass this class to add some functionality.
 */
NS_SWIFT_NAME(LateResponder)
@interface OCLateResponder : OCResponder


/**
 Convenience initializer that uses 0 for weight

 @return a newly initialized instance
 */
- (instancetype)init;

/**
 Initializes a new late responder with the specified weight
 
 @return a newly initialized instance
 */
- (instancetype)initWithWeight:(NSInteger)weight NS_DESIGNATED_INITIALIZER;


/** The weight for this responder. This is only used to sort the late responder chain. */
@property (nonatomic, readonly) NSInteger weight;

/** The associated registry. This is automatically sent when registering this responder with a registry. */
@property (nonatomic, nullable, weak) OCLateResponderRegistry *registry;

/**
 Deregisters this responder from its current registry.
 */
- (void)deregister;

@end

NS_ASSUME_NONNULL_END
