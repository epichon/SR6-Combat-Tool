//
//  StringtoActorType.m
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
#import "StringtoActorType.h"

@implementation StringtoActorType
+(Class)transformedValueClass {
    return [NSString class];
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    // Int to string.
    if (value == nil) {
        return (nil);
    } else {
        int iValue = [value intValue];
        
        if (iValue ==0) {
            return @"Normal";
        } else if (iValue == 1) {
            return @"Awakened";
        } else if (iValue == 2) {
            return @"Spirit";
        } else if (iValue == 3) {
            return @"Critter";
        } else if (iValue == 4) {
            return @"IC";
        } else if (iValue == 5) {
            return @"Agent";
        } else if (iValue == 6) {
            return @"Drone";
        } else if (iValue == 7) {
            return @"Vehicle";
        } else if (iValue == 8) {
            return @"Technomancer";
        } else if (iValue == 9) {
            return @"Sprite";
        } else if (iValue == 10) {
            return @"Technocritter";
        } else {
            return @"Normal";
        }
    }
}

-(id)reverseTransformedValue:(id)value {
    // String to Int
    if (value == nil) {
        return (nil);
    } else {
        if ([value isEqualToString:@"Normal"]) {
            return ([NSNumber numberWithInt:0]);
        } else if ([value isEqualToString:@"Awakened"]) {
            return ([NSNumber numberWithInt:1]);
        } else if ([value isEqualToString:@"Spirit"]) {
            return ([NSNumber numberWithInt:2]);
        } else if ([value isEqualToString:@"Critter"]) {
            return ([NSNumber numberWithInt:3]);
        } else if ([value isEqualToString:@"IC"]) {
            return ([NSNumber numberWithInt:4]);
        } else if ([value isEqualToString:@"Agent"]) {
            return ([NSNumber numberWithInt:5]);
        } else if ([value isEqualToString:@"Drone"]) {
            return ([NSNumber numberWithInt:6]);
        } else if ([value isEqualToString:@"Vehicle"]) {
            return ([NSNumber numberWithInt:7]);
        } else if ([value isEqualToString:@"Technomancer"]) {
            return ([NSNumber numberWithInt:8]);
        } else if ([value isEqualToString:@"Sprite"]) {
            return ([NSNumber numberWithInt:9]);
        } else if ([value isEqualToString:@"Technocritter"]) {
            return ([NSNumber numberWithInt:10]);
        } else {
            return ([NSNumber numberWithInt:0]);
        }
    }
}

@end
