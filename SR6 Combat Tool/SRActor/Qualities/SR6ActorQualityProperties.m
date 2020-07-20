//
//  SR6ActorSpell+CoreDataProperties.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorQualityProperties.h"

@implementation SR6ActorQuality (CoreDataProperties)

+ (NSFetchRequest<SR6ActorQuality *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorQuality"];
}

@dynamic option;
@dynamic uuid;
@dynamic level;
@dynamic actor;
@dynamic qualityInfo;

@end
