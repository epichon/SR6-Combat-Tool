//
//  SR6SpellProperties.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "SR6SpellProperties.h"

@implementation SR6Spell (CoreDataProperties)

+ (NSFetchRequest<SR6Spell *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"SR6Spell"];
}

@dynamic category;
@dynamic damage;
@dynamic drain;
@dynamic duration;
@dynamic range;
@dynamic type;
@dynamic longDesc;
@dynamic name;
@dynamic optionName;
@dynamic reference;
@dynamic shortDesc;
@dynamic spellUUID;

@end
