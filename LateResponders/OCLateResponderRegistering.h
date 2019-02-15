//
//  OCLateResponderRegistering.h
//  LateResponders
//
// Created by Paulo Andrade on 15/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCLateResponderRegistry.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OCLateResponderRegistering <NSObject>

@property (nonatomic, strong, readonly) OCLateResponderRegistry *lateResponderRegistry;

@end


@interface InterfaceKitViewController (OCLateResponderRegistering)

- (InterfaceKitViewController<OCLateResponderRegistering> *)lateResponderRegisteringViewController;

@end

NS_ASSUME_NONNULL_END
