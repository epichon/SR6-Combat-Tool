//
//  SR6ActorWeapon+CoreDataProperties.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/13.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorWeaponProperties.h"

@implementation SR6ActorWeapon (CoreDataProperties)

+ (NSFetchRequest<SR6ActorWeapon *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorWeapon"];
}

@dynamic level;
@dynamic notes;
@dynamic uuid;
@dynamic ammoCount;
@dynamic ammoSource;
@dynamic ammoType;
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
@dynamic wirelessMode;
@dynamic count;
@dynamic firingMode;
@dynamic weaponInfo;
@dynamic actor;

@end
