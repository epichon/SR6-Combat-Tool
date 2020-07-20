//
//  SR6SpellProperties.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SR6Spell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6Spell (CoreDataProperties)

+ (NSFetchRequest<SR6Spell *> *)fetchRequest;

@property (nonatomic) sr6SpellCategory category;
@property (nonatomic) sr6SpellDamage damage;
@property (nonatomic) int16_t drain;
@property (nonatomic) sr6Duration duration;
@property (nonatomic) sr6Range range;
@property (nonatomic) sr6PowerType type;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSUUID *spellUUID;

@end

NS_ASSUME_NONNULL_END
