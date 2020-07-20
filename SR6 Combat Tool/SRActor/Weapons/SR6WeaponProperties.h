//
//  SR6Weapon+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/12.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Weapon.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6Weapon (CoreDataProperties)

+ (NSFetchRequest<SR6Weapon *> *)fetchRequest;

@property (nonatomic) sr6WeaponCategory category;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSUUID *weaponUUID;
@property (nonatomic) int16_t damageNumber;
@property (nonatomic) sr6WeaponDamageType damageType;
@property (nullable, nonatomic, copy) NSString *damageSpecial;
@property (nonatomic) BOOL modeSS;
@property (nonatomic) BOOL modeSA;
@property (nonatomic) BOOL modeBF;
@property (nonatomic) BOOL modeBFS;
@property (nonatomic) BOOL modeFA;
@property (nonatomic) BOOL modeSpecial;
@property (nonatomic) int16_t ammoCount1;
@property (nonatomic) sr6WeaponAmmoContainer ammoType1;
@property (nonatomic) int16_t availLetter;
@property (nonatomic) int16_t availNumber;
@property (nullable, nonatomic, copy) NSDecimalNumber *cost;
@property (nonatomic) int16_t ammoCount2;
@property (nonatomic) sr6WeaponAmmoContainer ammoType2;
@property (nonatomic) int16_t arClose;
@property (nonatomic) int16_t arNear;
@property (nonatomic) int16_t arMedium;
@property (nonatomic) int16_t arFar;
@property (nonatomic) int16_t arExtreme;
@property (nonatomic) int16_t damageGroundZeroNumber;
@property (nonatomic) int16_t blast;
@property (nonatomic) BOOL level;
@property (nonatomic) int16_t maxLevel;
@property (nullable, nonatomic, copy) NSString *levelName;
@property (nonatomic) int16_t skill;

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

@end

NS_ASSUME_NONNULL_END
