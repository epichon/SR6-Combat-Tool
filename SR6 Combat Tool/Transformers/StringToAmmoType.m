//
//  StringToAmmoType.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/14.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "StringToAmmoType.h"
#import "SR6Weapon.h"

@implementation StringToAmmoType

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
        
        if (iValue == kWeaponAmmoTypeRegular) {
            return SR6_WEAPON_AMMO_REGULAR_LONG;
        } else if (iValue == kWeaponAmmoTypeAPDS) {
            return SR6_WEAPON_AMMO_APDS_LONG;
        } else if (iValue == kWeaponAmmoTypeExplosive) {
            return SR6_WEAPON_AMMO_EXPLOSIVE_LONG;
        } else if (iValue == kWeaponAmmoTypeFlechette) {
            return SR6_WEAPON_AMMO_FLECHETTE_LONG;
        } else if (iValue == kWeaponAmmoTypeGel) {
            return SR6_WEAPON_AMMO_GEL_LONG;
        } else if (iValue == kWeaponAmmoTypeStickNShock) {
            return SR6_WEAPON_AMMO_STICK_N_SHOCK_LONG;
        } else if (iValue == kWeaponAmmoTypeSpecial) {
            return SR6_WEAPON_AMMO_SPECIAL_LONG;
        } else if (iValue == kWeaponAmmoTypeHandLoaded) {
            return SR6_WEAPON_AMMO_HAND_LOADED_LONG;
        } else if (iValue == kWeaponAmmoTypeMatchGrade) {
            return SR6_WEAPON_AMMO_MATCH_GRADE_LONG;
        } else if (iValue == kWeaponAmmoTypeNone){
            return SR6_WEAPON_AMMO_NONE_LONG;
        } else {
            return SR6_WEAPON_AMMO_NONE_LONG;
        }
    }
}

-(id)reverseTransformedValue:(id)value {
    // String to Int
    if (value == nil) {
        return (nil);
    } else {
        if ([value isEqualToString:SR6_WEAPON_AMMO_REGULAR_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeRegular]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_APDS_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeAPDS]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_EXPLOSIVE_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeExplosive]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_FLECHETTE_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeFlechette]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_GEL_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeGel]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_STICK_N_SHOCK_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeStickNShock]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_SPECIAL_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeSpecial]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_HAND_LOADED_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeHandLoaded]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_MATCH_GRADE_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeMatchGrade]);
        } else if ([value isEqualToString:SR6_WEAPON_AMMO_NONE_LONG]) {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeNone]);
        } else {
            return ([NSNumber numberWithInt:kWeaponAmmoTypeNone]);
        }
    }
}

@end
