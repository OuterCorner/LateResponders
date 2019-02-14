//
//  InterfaceKit.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef InterfaceKit_h
#define InterfaceKit_h

#if TARGET_OS_OSX // macOS

#import <AppKit/AppKit.h>

#elif TARGET_OS_IOS // iOS

#import <UIKit/UIKit.h>

#else // who knows!

#error "Unsupported target"

#endif

#endif /* InterfaceKit_h */
