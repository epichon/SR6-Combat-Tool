//
//  SR6ActorPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorMetamagicProperties.h"

@implementation SR6ActorMetamagic (CoreDataProperties)

+ (NSFetchRequest<SR6ActorMetamagic *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorMetamagic"];
}

@dynamic level;
@dynamic option;
@dynamic uuid;
@dynamic actor;
@dynamic metamagicInfo;

@end
