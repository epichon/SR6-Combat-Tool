//
//  SR6Weapon+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/12.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Weapon.h"

@interface SR6Weapon ()

- (NSString *) ammoShortString: (sr6WeaponAmmoContainer) ammoType ;
- (NSString *) ammoLongString: (sr6WeaponAmmoContainer) ammoType ;

@end

@implementation SR6Weapon

-(NSString *) tableName {
    return(self.name);
}

-(NSString *) summary {
    if (_summary == nil) {
        _summary = [NSString stringWithFormat:@"%@ %@ %@",self.categoryShortString, self.damageString, self.arString];
    }
    return (_summary);
}

- (NSString *) categoryShortString {
    switch (self.category) {
        case kWeaponCatBlade:
            return (SR6_WEAPON_CAT_BLADE_SHORT);
            break;
        case kWeaponCatClub:
            return (SR6_WEAPON_CAT_CLUB_SHORT);
            break;
        case kWeaponCatMelee:
            return (SR6_WEAPON_CAT_MELEE_SHORT);
            break;
        case kWeaponCatThrown:
            return (SR6_WEAPON_CAT_THROWN_SHORT);
            break;
        case kWeaponCatTaser:
            return (SR6_WEAPON_CAT_TASER_SHORT);
            break;
        case kWeaponCatHoldOut:
            return (SR6_WEAPON_CAT_HOLD_OUT_SHORT);
            break;
        case kWeaponCatLightPistol:
            return (SR6_WEAPON_CAT_LIGHT_PISTOL_SHORT);
            break;
        case kWeaponCatMachinePistol:
            return (SR6_WEAPON_CAT_MACHINE_PISTOL_SHORT);
            break;
        case kWeaponCatHeavyPistol:
            return (SR6_WEAPON_CAT_HEAVY_PISTOL_SHORT);
            break;
        case kWeaponCatSMG:
            return (SR6_WEAPON_CAT_SMG_SHORT);
            break;
        case kWeaponCatShotgun:
            return (SR6_WEAPON_CAT_SHOTGUN_SHORT);
            break;
        case kWeaponCatRifle:
            return (SR6_WEAPON_CAT_RIFLE_SHORT);
            break;
        case kWeaponCatMachineGun:
            return (SR6_WEAPON_CAT_MACHINE_GUN_SHORT);
            break;
        case kWeaponCatAssaultCannon:
            return (SR6_WEAPON_CAT_ASSAULT_CANNON_SHORT);
            break;
        case kWeaponCatLauncher:
            return (SR6_WEAPON_CAT_LAUNCHER_SHORT);
            break;
        case kWeaponCatRocket:
            return (SR6_WEAPON_CAT_ROCKET_SHORT);
            break;
        case kWeaponCatMissile:
            return (SR6_WEAPON_CAT_MISSILE_SHORT);
            break;
        case kWeaponCatGrenade:
            return (SR6_WEAPON_CAT_GRENADE_SHORT);
            break;
        case kWeaponCatSpecial:
            return (SR6_WEAPON_CAT_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) categoryLongString {
    switch (self.category) {
        case kWeaponCatBlade:
            return (SR6_WEAPON_CAT_BLADE_LONG);
            break;
        case kWeaponCatClub:
            return (SR6_WEAPON_CAT_CLUB_LONG);
            break;
        case kWeaponCatMelee:
            return (SR6_WEAPON_CAT_MELEE_LONG);
            break;
        case kWeaponCatThrown:
            return (SR6_WEAPON_CAT_THROWN_LONG);
            break;
        case kWeaponCatTaser:
            return (SR6_WEAPON_CAT_TASER_LONG);
            break;
        case kWeaponCatHoldOut:
            return (SR6_WEAPON_CAT_HOLD_OUT_LONG);
            break;
        case kWeaponCatLightPistol:
            return (SR6_WEAPON_CAT_LIGHT_PISTOL_LONG);
            break;
        case kWeaponCatMachinePistol:
            return (SR6_WEAPON_CAT_MACHINE_PISTOL_LONG);
            break;
        case kWeaponCatHeavyPistol:
            return (SR6_WEAPON_CAT_HEAVY_PISTOL_LONG);
            break;
        case kWeaponCatSMG:
            return (SR6_WEAPON_CAT_SMG_LONG);
            break;
        case kWeaponCatShotgun:
            return (SR6_WEAPON_CAT_SHOTGUN_LONG);
            break;
        case kWeaponCatRifle:
            return (SR6_WEAPON_CAT_RIFLE_LONG);
            break;
        case kWeaponCatMachineGun:
            return (SR6_WEAPON_CAT_MACHINE_GUN_LONG);
            break;
        case kWeaponCatAssaultCannon:
            return (SR6_WEAPON_CAT_ASSAULT_CANNON_LONG);
            break;
        case kWeaponCatLauncher:
            return (SR6_WEAPON_CAT_LAUNCHER_LONG);
            break;
        case kWeaponCatRocket:
            return (SR6_WEAPON_CAT_ROCKET_LONG);
            break;
        case kWeaponCatMissile:
            return (SR6_WEAPON_CAT_MISSILE_LONG);
            break;
        case kWeaponCatGrenade:
            return (SR6_WEAPON_CAT_GRENADE_LONG);
            break;
        case kWeaponCatSpecial:
            return (SR6_WEAPON_CAT_SPECIAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) ammoShortString1 {
    return ([self ammoShortString:self.ammoType1]);
}

- (NSString *) ammoShortString2 {
    return ([self ammoShortString:self.ammoType2]);
}


- (NSString *) ammoLongString1 {
    return ([self ammoLongString: self.ammoType1]);
}

- (NSString *) ammoLongString2 {
    return ([self ammoLongString: self.ammoType2]);
}

-(NSString *) ammoShortString: (sr6WeaponAmmoContainer) ammoType {
    switch (ammoType) {
        case kWeaponAmmoContainerBelt:
            return (SR6_AMMO_CONTAINER_BELT_SHORT);
            break;
        case kWeaponAmmoContainerBreak:
            return (SR6_AMMO_CONTAINER_BREAK_SHORT);
            break;
        case kWeaponAmmoContainerClip:
            return (SR6_AMMO_CONTAINER_CLIP_SHORT);
            break;
        case kWeaponAmmoContainerCylinder:
            return (SR6_AMMO_CONTAINER_CYLINDER_SHORT);
            break;
        case kWeaponAmmoContainerDrum:
            return (SR6_AMMO_CONTAINER_DRUM_SHORT);
            break;
        case kWeaponAmmoContainerMagazine:
            return (SR6_AMMO_CONTAINER_MAGAZINE_SHORT);
            break;
        case kWeaponAmmoContainerMissile:
            return (SR6_AMMO_CONTAINER_MISSILE_SHORT);
            break;
        case kWeaponAmmoContainerMuzzle:
            return (SR6_AMMO_CONTAINER_MUZZLE_SHORT);
            break;
        case kWeaponAmmoContainerSpecial:
            return (SR6_AMMO_CONTAINER_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

-(NSString *) ammoLongString: (sr6WeaponAmmoContainer) ammoType {
    switch (ammoType) {
        case kWeaponAmmoContainerBelt:
            return (SR6_AMMO_CONTAINER_BELT_LONG);
            break;
        case kWeaponAmmoContainerBreak:
            return (SR6_AMMO_CONTAINER_BREAK_LONG);
            break;
        case kWeaponAmmoContainerClip:
            return (SR6_AMMO_CONTAINER_CLIP_LONG);
            break;
        case kWeaponAmmoContainerCylinder:
            return (SR6_AMMO_CONTAINER_CYLINDER_LONG);
            break;
        case kWeaponAmmoContainerDrum:
            return (SR6_AMMO_CONTAINER_DRUM_LONG);
            break;
        case kWeaponAmmoContainerMagazine:
            return (SR6_AMMO_CONTAINER_MAGAZINE_LONG);
            break;
        case kWeaponAmmoContainerMissile:
            return (SR6_AMMO_CONTAINER_MISSILE_LONG);
            break;
        case kWeaponAmmoContainerMuzzle:
            return (SR6_AMMO_CONTAINER_MUZZLE_LONG);
            break;
        case kWeaponAmmoContainerSpecial:
            return (SR6_AMMO_CONTAINER_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) arString {
    return ([NSString stringWithFormat:@"%@/%@/%@/%@/%@",[self arLetter:self.arClose],[self arLetter:self.arNear],[self arLetter:self.arMedium],[self arLetter:self.arFar],[self arLetter:self.arExtreme]]);
}
    

-(NSString *)arLetter:(int16_t)arCode {
    if (arCode == 0) {
        return (@"-");
    } else {
        return ([NSString stringWithFormat:@"%d",arCode]);
    }
}
             
- (NSString *)fireModesString {
    NSMutableString *tmp = [[NSMutableString alloc] initWithCapacity:10];
    
    if (self.modeSS) {
        [tmp appendString:SR6_FIRING_MODE_SS_SHORT];
        [tmp appendString:@"/"];
    }
    if (self.modeSA) {
        [tmp appendString:SR6_FIRING_MODE_SA_SHORT];
        [tmp appendString:@"/"];
    }
    if (self.modeBF) {
        [tmp appendString:SR6_FIRING_MODE_BF_SHORT];
        [tmp appendString:@"/"];
    }
    if (self.modeFA) {
        [tmp appendString:SR6_FIRING_MODE_FA_SHORT];
        [tmp appendString:@"/"];
    }
    if (self.modeSpecial){
        [tmp appendString:SR6_FIRING_MODE_SPECIAL_SHORT];
        [tmp appendString:@"/"];
    }
    if ([tmp length] > 0) {
        return([tmp substringToIndex:([tmp length] -1)]);
    } else {
        return (NSString *)tmp;
    }
}

- (NSString *)damageTypeShortString {
    switch (self.damageType) {
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

- (NSString *)damageTypeLongString {
    switch (self.damageType) {
        case kWeaponDamageTypeStun:
            return (SR6_WEAPON_DMG_STUN_LONG);
            break;
        case kWeaponDamageTypePhysical:
            return (SR6_WEAPON_DMG_PHYSICAL_LONG);
            break;
        case kWeaponDamageTypeBlinded:
            return (SR6_WEAPON_DMG_BLINDED_LONG);
            break;
        case kWeaponDamageTypeSpecial:
            return (SR6_WEAPON_DMG_SPEICAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *)damageString {
    if(self.damageType == kWeaponDamageTypeSpecial) {
        return (self.damageSpecial);
    } else {
        return ([NSString stringWithFormat:@"%d%@",self.damageNumber,[self damageTypeLongString]]);
    }
}
             
@end
