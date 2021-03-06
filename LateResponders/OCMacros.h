//
//  OCMacros.h
//  LateResponders
//
// Created by Paulo Andrade on 14/02/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#ifndef OCMacros_h
#define OCMacros_h

#if TARGET_OS_OSX // macOS

#define InterfaceKitResponder NSResponder
#define InterfaceKitViewController NSViewController

#elif TARGET_OS_IOS // iOS

#define InterfaceKitResponder UIResponder
#define InterfaceKitViewController UIViewController

#else // who knows!

#error "Unsupported target"

#endif

#endif /* OCMacros_h */
