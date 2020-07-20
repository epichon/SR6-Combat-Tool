//
//  BoolToDisabledColor.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/17.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/
#import "BoolToDisabledColor.h"
#import <AppKit/AppKit.h>

@implementation BoolToDisabledColor

+(Class)transformedValueClass {
    return [NSColor class];
}


-(id)transformedValue:(id)value {
    BOOL enabled = (BOOL) [value intValue];
    
    if (enabled) {
        return ([NSColor labelColor]);
    } else {
        return ([NSColor disabledControlTextColor]);
    }
}

@end
