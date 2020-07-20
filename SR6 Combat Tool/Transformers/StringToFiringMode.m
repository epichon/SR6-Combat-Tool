//
//  StringToFiringMode.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/14.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "StringToFiringMode.h"
#import "SR6Constants.h"

@implementation StringToFiringMode

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
        
        if (iValue == kWeaponFiringModeSingleShot) {
            return SR6_FIRING_MODE_SS_SHORT;
        } else if (iValue == kWeaponFiringModeSemiAutomatic) {
            return SR6_FIRING_MODE_SA_SHORT;
        } else if (iValue == kWeaponFiringModeBurstNarrow) {
            return SR6_FIRING_MODE_BN_SHORT;
        } else if (iValue == kWeaponFiringModeBurstWide) {
            return SR6_FIRING_MODE_BW_SHORT;
        } else if (iValue == kWeaponFiringModeFullAuto) {
            return SR6_FIRING_MODE_FA_SHORT;
        } else if (iValue == kWeaponFiringModeOther) {
            return SR6_FIRING_MODE_OTHER_SHORT;
        } else if (iValue == kWeaponFiringModeNA) {
            return SR6_FIRING_MODE_NA_SHORT;
        } else {
            return @"ERR";
        }
    }
}

-(id)reverseTransformedValue:(id)value {
    // String to Int
    if (value == nil) {
        return (nil);
    } else {
        if ([value isEqualToString:SR6_FIRING_MODE_SS_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeSingleShot]);
        } else if ([value isEqualToString:SR6_FIRING_MODE_SA_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeSemiAutomatic]);
        } else if ([value isEqualToString:SR6_FIRING_MODE_BN_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeBurstNarrow]);
        } else if ([value isEqualToString:SR6_FIRING_MODE_BW_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeBurstWide]);
        } else if ([value isEqualToString:SR6_FIRING_MODE_FA_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeFullAuto]);
        } else if ([value isEqualToString:SR6_FIRING_MODE_OTHER_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeOther]);
        } else if ([value isEqualToString:SR6_FIRING_MODE_NA_SHORT]) {
            return ([NSNumber numberWithInt:kWeaponFiringModeNA]);
        } else {
            return ([NSNumber numberWithInt:0]);
        }
    }
}

@end
