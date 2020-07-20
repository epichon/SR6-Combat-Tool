//
//  SR6Weapon+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/12.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6WeaponProperties.h"

@implementation SR6Weapon (CoreDataProperties)

+ (NSFetchRequest<SR6Weapon *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Weapon"];
}

@dynamic category;
@dynamic longDesc;
@dynamic name;
@dynamic reference;
@dynamic shortDesc;
@dynamic weaponUUID;
@dynamic damageNumber;
@dynamic damageType;
@dynamic damageSpecial;
@dynamic modeSS;
@dynamic modeSA;
@dynamic modeBF;
@dynamic modeBFS;
@dynamic modeFA;
@dynamic modeSpecial;
@dynamic ammoCount1;
@dynamic ammoType1;
@dynamic availLetter;
@dynamic availNumber;
@dynamic cost;
@dynamic ammoCount2;
@dynamic ammoType2;
@dynamic arClose;
@dynamic arNear;
@dynamic arMedium;
@dynamic arFar;
@dynamic arExtreme;
@dynamic damageGroundZeroNumber;
@dynamic blast;
@dynamic level;
@dynamic maxLevel;
@dynamic levelName;
@dynamic skill;

@dynamic airburstLink;
@dynamic bipod;
@dynamic gasVent;
@dynamic gyroMount;
@dynamic imagingScope;
@dynamic laserSight;
@dynamic shockPad;
@dynamic silencer;
@dynamic smartFiringPlatform;
@dynamic smartLink;
@dynamic tripod;

@end
