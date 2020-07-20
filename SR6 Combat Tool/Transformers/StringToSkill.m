//
//  StringToSkill.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/02.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/
// This transformer is for used with level-type actors (spirits, sprites, etc.)
// If in level mode, it turns a 0 into a "-", and 1 one into the level tag ("L", "F", "R")
// Otherwise it just passes along the number values.
// It determines what "mode" it is in, by looking at the levelLabel property - if it's empty, we're normal
// otherwise use the label value.

#import "StringToSkill.h"

@implementation StringToSkill

@synthesize levelLabel;

+(Class)transformedValueClass {
    return [NSString class];
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    if (value == nil) {
        return (nil);
    } else {
        int iValue = [value intValue];
        if ([levelLabel isEqualToString:@""]) { // We are in normal mode.
            return ([value stringValue]);
        } else {
            if (iValue == 0) {
                return @"–";
            } else {
                return levelLabel;
            }
        }
    }
}

-(id)reverseTransformedValue:(id)value {
    if (value == nil) {
        return (nil);
    } else {
        if ([levelLabel isEqualToString:@""]) {
            return ([NSNumber numberWithInt:[value intValue]]);
        } else {
            if ([value isEqualToString:levelLabel]) {
                return ([NSNumber numberWithInt:0]);
            } else {
                return ([NSNumber numberWithInt:1]);
            }
        }
    }
}

@end
