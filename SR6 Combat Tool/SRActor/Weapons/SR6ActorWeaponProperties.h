//
//  SR6ActorWeapon+CoreDataProperties.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/13.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorWeapon.h"
#import "SR6Weapon.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorWeapon (CoreDataProperties)

+ (NSFetchRequest<SR6ActorWeapon *> *)fetchRequest;

@property (nonatomic) int16_t level;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSUUID *uuid;
@property (nonatomic) int16_t ammoSource;
@property (nonatomic) int16_t ammoCount;
@property (nonatomic) sr6WeaponAmmoType ammoType;
@property (nonatomic) BOOL airburstLink;
@property (nonatomic) BOOL bipod;
@property (nonatomic) BOOL gasVent;
@property (nonatomic) BOOL gyroMount;
@property (nonatomic) BOOL imagingScope;
@property (nonatomic) BOOL laserSight;
@property (nonatomic) BOOL shockPad;
@property (nonatomic) BOOL silencer;
@property (nonatomic) BOOL smartFiringPlatform;
@property (nonatomic) BOOL smartLink;
@property (nonatomic) BOOL tripod;
@property (nonatomic) BOOL wirelessMode;
@property (nonatomic) int16_t count;
@property (nonatomic) sr6WeaponFiringMode firingMode;

@property (nullable, nonatomic, retain) SR6Actor *actor;
@property (nullable, nonatomic, retain) NSArray *weaponInfo;

@end

NS_ASSUME_NONNULL_END
