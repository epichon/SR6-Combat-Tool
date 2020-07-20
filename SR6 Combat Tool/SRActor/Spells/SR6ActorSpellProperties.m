//
//  SR6ActorSpell+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/28.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorSpellProperties.h"

@implementation SR6ActorSpell (CoreDataProperties)

+ (NSFetchRequest<SR6ActorSpell *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorSpell"];
}

@dynamic uuid;
@dynamic option;
@dynamic numberHits;
@dynamic sustained;
@dynamic actor;
@dynamic spellInfo;

@end
