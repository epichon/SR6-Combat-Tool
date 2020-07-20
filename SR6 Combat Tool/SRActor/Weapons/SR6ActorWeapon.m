//
//  SR6ActorWeapon+CoreDataClass.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/13.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorWeapon.h"
#import "SR6Weapon.h"
#import "SR6Actor.h"

@implementation SR6ActorWeapon

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"weaponInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"weaponInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingDvAdjusted {
    return [NSSet setWithObjects:@"weaponInfo",@"ammoType",@"firingMode",@"level",@"bipod",@"gasVent",@"gyroMount",@"laserSight",
            @"shockPad",@"smartFiringPlatform",@"smartLink",@"tripod",@"wirelessMode", nil];
}

+(NSSet *)keyPathsForValuesAffectingArsAdjusted {
    return [NSSet setWithObjects:@"weaponInfo",@"ammoType",@"firingMode",@"level",@"bipod",@"gasVent",@"gyroMount",@"laserSight",
    @"shockPad",@"smartFiringPlatform",@"smartLink",@"tripod",@"wirelessMode", nil];
}

-(BOOL) showAmmo {
    // Show ammo if there is any.
    return (self.weapon.ammoCount1 > 0 || self.weapon.ammoCount2 > 0);
}

-(BOOL) showCount {
    // Could do this based on type, but why restrict?
    return YES;
}

-(BOOL) showFiringMode {
    return ([self.firingModes count] > 1);
}

-(BOOL) showLevel {
    return (self.weapon.level);
}

-(BOOL) allowSourceSelect {
    return ([self.ammoSources count] > 1);
}

-(void) resetAccessories {
    self.airburstLink = self.weapon.airburstLink;
    self.bipod = self.weapon.bipod;
    self.gasVent = self.weapon.gasVent;
    self.gyroMount = self.weapon.gyroMount;
    self.imagingScope = self.weapon.imagingScope;
    // We don't do laser sights, as the ARs already include them,
    // which is a right pain in the keister.
    // self.laserSight = self.weapon.laserSight;
    self.shockPad = self.weapon.shockPad;
    self.silencer = self.weapon.silencer;
    self.smartFiringPlatform = self.weapon.smartFiringPlatform;
    self.smartLink = self.weapon.smartLink;
    self.tripod = self.weapon.tripod;
}

-(void) reload {
    self.ammoCount = [self ammoMax];
    
    // Thought about allowing tactical reloads, but it caused
    // issues with maximums and such.
    /*4
    sr6WeaponAmmo tmp;
    
    
    if (self.ammoSource == 0)
        tmp = self.weapon.ammoType1;
    else {
        tmp = self.weapon.ammoType2;
    }
    if (tmp == kWeaponAmmoClip || tmp == kWeaponAmmoDrum) {
        if (self.weapon.modeSA || self.weapon.modeBF || self.weapon.modeFA) {
            self.ammoCount = [self ammoMax] +1;
        }
    }*/
}

-(void) fireWeapon {
    int16_t ammo;
    switch (self.firingMode) {
        case kWeaponFiringModeSingleShot:
            ammo = self.ammoCount -1;
            break;
        case kWeaponFiringModeSemiAutomatic:
            ammo = self.ammoCount -2;
            break;
        case kWeaponFiringModeBurstNarrow:
        case kWeaponFiringModeBurstWide:
            ammo = self.ammoCount -4;
            break;
        case kWeaponFiringModeFullAuto:
            ammo = self.ammoCount -10;
            break;
        default:
            ammo = self.ammoCount;
            break;
    }
    if (ammo < 0) {
        ammo = 0;
    }
    self.ammoCount = ammo;
}

-(NSString *) tableName {
    if (self.weapon.level == false) {
        return(self.weapon.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%d]",self.weapon.name,self.level]);
    }
}

-(NSString *)testName {
    // Give the test name, in the form of "Roll skill + Agility"
    // First, we need to get the skill string.
    // Luckily, we have a method in the actor that does this.
    return ([NSString stringWithFormat:@"Roll %@ + Agility",[self.actor getStringForSkill:self.weapon.skill]]);
}



-(int16_t) ammoMax {
    if (self.ammoSource == 0) {
        return (self.weapon.ammoCount1);
    } else {
        return (self.weapon.ammoCount2);
    }
}

-(NSArray *)ammoSources {
    if (_ammoSources == nil) {
        if (self.weapon.ammoCount1 == 0) {
            // This has no ammo, so mark it as such.
            _ammoSources = [NSArray arrayWithObject:@"–None–"];
        } else if (self.weapon.ammoCount2 == 0) {
            // We just have one ammo type.
            _ammoSources = [NSArray arrayWithObject:[NSString stringWithFormat:@"%d (%@)",self.weapon.ammoCount1, self.weapon.ammoLongString1]];
        } else {
            // We have two ammo sources...
            _ammoSources = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d (%@)",self.weapon.ammoCount1, self.weapon.ammoLongString1],
                            [NSString stringWithFormat:@"%d (%@)",self.weapon.ammoCount2, self.weapon.ammoLongString2], nil];
        }
    }
    return (_ammoSources);
}

- (void) setAmmoSourceString:(NSString *)ammoSourceString {
    _ammoSourceString = ammoSourceString;
    
    // Now, update the index. In theory we only can have two sources, but for giggles, this can handle just about anything.
    if ([self.ammoSources count] <= 1) {
        self.ammoSource = 0;
    } else {
        NSUInteger index;
        for (index = 0; index < [self.ammoSources count]; index ++) {
            if ([[self.ammoSources objectAtIndex:index] isEqualToString:ammoSourceString]) {
                self.ammoSource = index;
                return;
            }
        }
        // If we got to here, we didn't find it.
        NSLog(@"SR6ActorWeapon -> Didn't find ammoSourceString in sources: %@",ammoSourceString);
    }
}

-(NSString *)ammoSourceString {
    if (_ammoSourceString == nil) {
        _ammoSourceString = [self.ammoSources objectAtIndex:self.ammoSource];
    }
    return _ammoSourceString;
}

-(NSArray *) firingModes {
    // Return an array of strings of the available firing modes.
    if (_firingModes == nil) {
        NSMutableArray * myArray = [NSMutableArray arrayWithCapacity:2];
        
        if (self.weapon.modeSS) {
            [myArray addObject:@"SS"];
        }
        if (self.weapon.modeSA) {
            [myArray addObject:@"SS"];
            [myArray addObject:@"SA"];
        }
        if (self.weapon.modeBF) {
            [myArray addObject:@"B-N"];
            [myArray addObject:@"B-W"];
        }
        if (self.weapon.modeFA) {
            [myArray addObject:@"FA"];
        }
        if (self.weapon.modeSpecial) {
            [myArray addObject:@"Spec"];
        }
        if ([myArray count] == 0) {
            [myArray addObject:@"-NA-"];
            self.firingMode = kWeaponFiringModeNA;
        }
        _firingModes = (NSArray *)myArray;
    }
    return (_firingModes);
}


- (NSString *) arsAdjusted {
    // Return the string of the ARs, adjusted for mods and ammo.
    int arNearMod, arCloseMod, arMediumMod, arFarMod, arExtremeMod;
    sr6WeaponDamageType dvType;
    
    // If this is an explosive (grenade/rocket/missile) we put the info here
    if (self.weapon.category == kWeaponCatRocket || self.weapon.category == kWeaponCatMissile || self.weapon.category == kWeaponCatGrenade ) {
        // Flash-pak's are hinky.
        if ([self.weapon.name isEqualToString:@"Flash-Pak"]) {
            return ([NSString stringWithFormat:@"III/II/I %dm",self.weapon.blast]);
        }
        // For gas weapons, we just do "Gas":
        if ([self.weapon.damageSpecial isEqualToString:@"Gas"]) {
            return (@"As Gas");
        } else if (self.weapon.damageType == kWeaponDamageTypeStun) {
            // Stun explosives weapons...
            return ([NSString stringWithFormat:@"%d/%d/%dS %dm",self.weapon.damageGroundZeroNumber, self.weapon.arClose,self.weapon.arNear,self.weapon.blast]);
        } else {
            return ([NSString stringWithFormat:@"%d/%d/%dP %dm",self.weapon.damageGroundZeroNumber, self.weapon.arClose,self.weapon.arNear,self.weapon.blast]);
        }
    }
    
    // We track as a modifier to the base, and do an evaluation at the end on whether to actually adjust the ARs.
    arNearMod = 0;
    arCloseMod = 0;
    arMediumMod = 0;
    arFarMod = 0;
    arExtremeMod = 0;
    dvType = self.weapon.damageType;
    
    if ([self.weapon.name isEqualToString:@"Bow"]) {
        // We have to do something special for bows. Alas.
        // The ARs will all be 0, so we set the AR mods to the base values.
        arCloseMod = self.level/2;
        arNearMod = self.level;
        arMediumMod = self.level/4;
    }
    
    // First, we deal with the ammo types.
    switch (self.ammoType) {
        case kWeaponAmmoTypeAPDS:
            arNearMod = arNearMod +2;
            arCloseMod = arCloseMod +2;
            arMediumMod = arMediumMod +2;
            arFarMod = arFarMod +2;
            arExtremeMod = arExtremeMod +2;
            break;
        case kWeaponAmmoTypeFlechette:
            arNearMod = arNearMod +1;
            arCloseMod = arCloseMod +1;
            arMediumMod = arMediumMod +1;
            arFarMod = arFarMod +1;
            arExtremeMod = arExtremeMod +1;
            break;
        case kWeaponAmmoTypeStickNShock:
            dvType = kWeaponDamageTypeStun;
            arNearMod = arNearMod +1;
            arCloseMod = arCloseMod +1;
            arMediumMod = arMediumMod +1;
            arFarMod = arFarMod +1;
            arExtremeMod = arExtremeMod +1;
            break;
        case kWeaponAmmoTypeHandLoaded:
            arNearMod = arNearMod +1;
            arCloseMod = arCloseMod +1;
            arMediumMod = arMediumMod +1;
            arFarMod = arFarMod +1;
            arExtremeMod = arExtremeMod +1;
            break;
        case kWeaponAmmoTypeMatchGrade:
            arNearMod = arNearMod +1;
            arCloseMod = arCloseMod +2;
            arMediumMod = arMediumMod +3;
            arFarMod = arFarMod +3;
            arExtremeMod = arExtremeMod +2;
            break;
        default:
            break;
    }
    
    // Now, handle the various mods. Some impacts are per firing mode, and are handled in the firing mode secion.
    if (self.bipod) {
        if (self.wirelessMode) {
            arNearMod = arNearMod +3;
            arCloseMod = arCloseMod +3;
            arMediumMod = arMediumMod +3;
            arFarMod = arFarMod +3;
            arExtremeMod = arExtremeMod +3;
        } else { // Wired
            arNearMod = arNearMod +2;
            arCloseMod = arCloseMod +2;
            arMediumMod = arMediumMod +2;
            arFarMod = arFarMod +2;
            arExtremeMod = arExtremeMod +2;
        }
    }
    if (self.laserSight && !self.smartLink) {// Not compat with SL.
        if (self.wirelessMode) {
            arNearMod = arNearMod +2;
            arCloseMod = arCloseMod +2;
            arMediumMod = arMediumMod +2;
            arFarMod = arFarMod +2;
            arExtremeMod = arExtremeMod +2;
        } else { // Wired
            arNearMod = arNearMod +1;
            arCloseMod = arCloseMod +1;
            arMediumMod = arMediumMod +1;
            arFarMod = arFarMod +1;
            arExtremeMod = arExtremeMod +1;
        }
    }
    if (self.smartLink) {
        arNearMod = arNearMod +2;
        arCloseMod = arCloseMod +2;
        arMediumMod = arMediumMod +2;
        arFarMod = arFarMod +2;
        arExtremeMod = arExtremeMod +2;
    }
    
    // Now handle the firing mode.
    switch (self.firingMode) {
        case kWeaponFiringModeSingleShot:
            // Nothing changes.
            break;
        case kWeaponFiringModeSemiAutomatic:
            if (self.gyroMount || self.smartFiringPlatform || self.tripod || self.gasVent) break;
            if (!self.shockPad) {
                arNearMod = arNearMod -2;
                arCloseMod = arCloseMod -2;
                arMediumMod = arMediumMod -2;
                arFarMod = arFarMod -2;
                arExtremeMod = arExtremeMod -2;
            } else {
                arNearMod = arNearMod -1;
                arCloseMod = arCloseMod -1;
                arMediumMod = arMediumMod -1;
                arFarMod = arFarMod -1;
                arExtremeMod = arExtremeMod -1;
            }
            break;
        case kWeaponFiringModeBurstNarrow:
            if (!(self.gyroMount || self.smartFiringPlatform || self.tripod )) {
                if (self.ammoCount >=4) {
                    arNearMod = arNearMod -4;
                    arCloseMod = arCloseMod -4;
                    arMediumMod = arMediumMod -4;
                    arFarMod = arFarMod -4;
                    arExtremeMod = arExtremeMod -4;
                } else {
                    arNearMod = arNearMod - self.ammoCount;
                    arCloseMod = arCloseMod -self.ammoCount;
                    arMediumMod = arMediumMod -self.ammoCount;
                    arFarMod = arFarMod -self.ammoCount;
                    arExtremeMod = arExtremeMod -self.ammoCount;
                }
                if (self.gasVent) {
                    arNearMod = arNearMod +2;
                    arCloseMod = arCloseMod +2;
                    arMediumMod = arMediumMod +2;
                    arFarMod = arFarMod +2;
                    arExtremeMod = arExtremeMod +2;
                }
                if (self.shockPad) {
                    arNearMod = arNearMod +1;
                    arCloseMod = arCloseMod +1;
                    arMediumMod = arMediumMod +1;
                    arFarMod = arFarMod +1;
                    arExtremeMod = arExtremeMod +1;
                }
            }
            break;
        case kWeaponFiringModeBurstWide:
            if (!self.gyroMount || self.smartFiringPlatform) {
                arNearMod = arNearMod -1;
                arCloseMod = arCloseMod -1;
                arMediumMod = arMediumMod -1;
                arFarMod = arFarMod -1;
                arExtremeMod = arExtremeMod -1;
            }
            break;
        case kWeaponFiringModeFullAuto:
            if (self.gyroMount || self.tripod || self.smartFiringPlatform) {
                arNearMod = arNearMod -3;
                arCloseMod = arCloseMod -3;
                arMediumMod = arMediumMod -3;
                arFarMod = arFarMod -3;
                arExtremeMod = arExtremeMod -3;
            } else {
                arNearMod = arNearMod -6;
                arCloseMod = arCloseMod -6;
                arMediumMod = arMediumMod -6;
                arFarMod = arFarMod -6;
                arExtremeMod = arExtremeMod -6;
            }
            break;
        default:
            break;
    }
    
    // Now we've got the adjustments.
    // So, now we get the final values by applying the mod, but only if the original is not 0.
    if ( ![self.weapon.name isEqualToString:@"Bow"]) { // Bows are hard coded weird, so we only do this check for non-bows.
        if (self.weapon.arClose >0) arCloseMod = self.weapon.arClose + arCloseMod;
        if (self.weapon.arNear >0) arNearMod = self.weapon.arNear + arNearMod;
        if (self.weapon.arMedium >0) arMediumMod = self.weapon.arMedium + arMediumMod;
        if (self.weapon.arFar >0) arFarMod = self.weapon.arFar + arFarMod;
        if (self.weapon.arExtreme >0) arExtremeMod = self.weapon.arExtreme + arExtremeMod;
    } else {
        // For bows, far and extreme can't happen, so set them to 0, and
        // just return the ratings as-is.
        arFarMod = 0;
        arExtremeMod = 0;
        return ([NSString stringWithFormat:@"%d/%d/%d/-/-",arCloseMod, arNearMod, arMediumMod]);
    }
    
    // Now we build the string. Ranges that had no AR need to stay at "–"
    // Everything else should be a numebr, even if it's zero.
    NSString *arCloseStr, *arNearStr, *arMediumStr, *arFarStr, *arExtremeStr;
    if (self.weapon.arClose == 0) {
        arCloseStr = @"-";
    } else {
        arCloseStr = [NSString stringWithFormat:@"%d",arCloseMod];
    }
    if (self.weapon.arNear == 0) {
        arNearStr = @"-";
    } else {
        arNearStr = [NSString stringWithFormat:@"%d",arNearMod];
    }
    if (self.weapon.arMedium == 0) {
        arMediumStr = @"-";
    } else {
        arMediumStr = [NSString stringWithFormat:@"%d",arMediumMod];
    }
    if (self.weapon.arFar == 0) {
        arFarStr = @"-";
    } else {
        arFarStr = [NSString stringWithFormat:@"%d",arFarMod];
    }
    if (self.weapon.arExtreme == 0) {
        arExtremeStr = @"-";
    } else {
        arExtremeStr = [NSString stringWithFormat:@"%d",arExtremeMod];
    }
    
    return ([NSString stringWithFormat:@"%@/%@/%@/%@/%@",arCloseStr, arNearStr, arMediumStr, arFarStr, arExtremeStr]);
}

- (NSString *)damageTypeShortString:(sr6WeaponDamageType) dvType {
    switch (dvType) {
        case kWeaponDamageTypeStun:
            return (SR6_WEAPON_DMG_STUN_SHORT);
            break;
        case kWeaponDamageTypePhysical:
            return (SR6_WEAPON_DMG_PHYSICAL_SHORT);
            break;
        case kWeaponDamageTypeBlinded:
            return (SR6_WEAPON_DMG_BLINDED_SHORT);
            break;
        case kWeaponDamageTypeSpecial:
            return (SR6_WEAPON_DMG_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) dvAdjusted {
    // Return the string of the ARs, adjusted for mods and ammo.
    int dvMod;
    sr6WeaponDamageType dvType;
    NSString *dmgSpecial;
    
    // We track as a modifier to the base, and do an evaluation at the end on whether to actually adjust the ARs.
    dvMod = 0;
    dvType = self.weapon.damageType;
    dmgSpecial = self.weapon.damageSpecial;
    
    if (self.weapon.damageType == kWeaponDamageTypeSpecial) return (self.weapon.damageSpecial);
    if (self.weapon.damageType == kWeaponDamageTypeBlinded) return (@"Blind");
    
    // First, we deal with the ammo types.
    switch (self.ammoType) {
        case kWeaponAmmoTypeAPDS:
            dvMod = dvMod -1;
            break;
        case kWeaponAmmoTypeExplosive:
            dvMod = dvMod +1;
            break;
        case kWeaponAmmoTypeFlechette:
            dvMod = dvMod -1;
            break;
        case kWeaponAmmoTypeGel:
            dvType = kWeaponDamageTypeStun;
            break;
        case kWeaponAmmoTypeStickNShock:
            dvMod = dvMod -1;
            dvType = kWeaponDamageTypeStun;
            dmgSpecial = @"(e)";
            break;
        case kWeaponAmmoTypeMatchGrade:
            dvMod = dvMod -1;
            break;
        default:
            break;
    }
    
    // Now handle the firing mode.
    switch (self.firingMode) {
        case kWeaponFiringModeSingleShot:
            // Nothing changes.
            break;
        case kWeaponFiringModeSemiAutomatic:
            dvMod = dvMod +1;
            break;
        case kWeaponFiringModeBurstNarrow:
            if (self.ammoCount >=4) {
                dvMod = dvMod +2;
            } else if (self.ammoCount >=2) {
                dvMod = dvMod +1;
            }
            break;
        case kWeaponFiringModeBurstWide:
            dvMod = dvMod +1;
            break;
        case kWeaponFiringModeFullAuto:
            break;
        default:
            break;
    }
    
    // Now we've got the adjustments.
    // So, now we get the final values by applying the mod.
    if ([self.weapon.name isEqualToString:@"Bow"]) {
        dvMod = self.level/2 + dvMod;
    } else {
        dvMod = self.weapon.damageNumber + dvMod;
    }
    // Now, build the string.
    if (dmgSpecial == nil || [dmgSpecial isEqualToString:@""]) {
        return ([NSString stringWithFormat:@"%d%@", dvMod, [self damageTypeShortString:dvType]]);
    } else {
        return ([NSString stringWithFormat:@"%d%@%@", dvMod, [self damageTypeShortString:dvType], dmgSpecial]);
    }
}

-(SR6Weapon *) weapon {
    if (_weapon == nil) {
        _weapon = [self.weaponInfo firstObject];
    }
    return (_weapon);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Weapon-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.ammoCount] forKey:[NSString stringWithFormat:@"%@-ammoCount",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.ammoSource] forKey:[NSString stringWithFormat:@"%@-ammoSource",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.ammoType] forKey:[NSString stringWithFormat:@"%@-ammoType",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.count] forKey:[NSString stringWithFormat:@"%@-count",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.airburstLink] forKey:[NSString stringWithFormat:@"%@-airburstLink",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.bipod] forKey:[NSString stringWithFormat:@"%@-bipod",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.gasVent] forKey:[NSString stringWithFormat:@"%@-gasVent",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.gyroMount] forKey:[NSString stringWithFormat:@"%@-gyroMount",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.imagingScope] forKey:[NSString stringWithFormat:@"%@-imagingScope",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.laserSight] forKey:[NSString stringWithFormat:@"%@-laserSight",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.shockPad] forKey:[NSString stringWithFormat:@"%@-shockPad",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.silencer] forKey:[NSString stringWithFormat:@"%@-silencer",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.smartFiringPlatform] forKey:[NSString stringWithFormat:@"%@-smartFiringPlatform",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.smartLink] forKey:[NSString stringWithFormat:@"%@-smartLink",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.tripod] forKey:[NSString stringWithFormat:@"%@-tripod",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.wirelessMode] forKey:[NSString stringWithFormat:@"%@-wirelessMode",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.firingMode] forKey:[NSString stringWithFormat:@"%@-firingMode",tag]];
    
    if (self.notes != nil) {
        [myDict setObject:self.notes forKey:[NSString stringWithFormat:@"%@-notes",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Weapon-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.ammoCount = [[myDict objectForKey:[NSString stringWithFormat:@"%@-ammoCount",tag]] intValue];
    self.ammoSource = [[myDict objectForKey:[NSString stringWithFormat:@"%@-ammoSource",tag]] intValue];
    self.ammoType = [[myDict objectForKey:[NSString stringWithFormat:@"%@-ammoType",tag]] intValue];
    self.count = [[myDict objectForKey:[NSString stringWithFormat:@"%@-count",tag]] intValue];
    self.airburstLink = [[myDict objectForKey:[NSString stringWithFormat:@"%@-airburstLink",tag]] intValue];
    self.bipod = [[myDict objectForKey:[NSString stringWithFormat:@"%@-bipod",tag]] intValue];
    self.gasVent = [[myDict objectForKey:[NSString stringWithFormat:@"%@-gasVent",tag]] intValue];
    self.gyroMount = [[myDict objectForKey:[NSString stringWithFormat:@"%@-gyroMount",tag]] intValue];
    self.imagingScope = [[myDict objectForKey:[NSString stringWithFormat:@"%@-imagingScope",tag]] intValue];
    self.laserSight = [[myDict objectForKey:[NSString stringWithFormat:@"%@-laserSight",tag]] intValue];
    self.shockPad = [[myDict objectForKey:[NSString stringWithFormat:@"%@-shockPad",tag]] intValue];
    self.silencer = [[myDict objectForKey:[NSString stringWithFormat:@"%@-silencer",tag]] intValue];
    self.smartFiringPlatform = [[myDict objectForKey:[NSString stringWithFormat:@"%@-smartFiringPlatform",tag]] intValue];
    self.smartLink = [[myDict objectForKey:[NSString stringWithFormat:@"%@-smartLink",tag]] intValue];
    self.tripod = [[myDict objectForKey:[NSString stringWithFormat:@"%@-tripod",tag]] intValue];
    self.wirelessMode = [[myDict objectForKey:[NSString stringWithFormat:@"%@-wirelessMode",tag]] intValue];
    self.firingMode = [[myDict objectForKey:[NSString stringWithFormat:@"%@-firingMode",tag]] intValue];
    
    self.notes = [myDict objectForKey:[NSString stringWithFormat:@"%@-notes",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
