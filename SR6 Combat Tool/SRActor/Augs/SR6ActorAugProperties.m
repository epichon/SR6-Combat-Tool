//
//  SR6ActorPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorAugProperties.h"

@implementation SR6ActorAug (CoreDataProperties)

+ (NSFetchRequest<SR6ActorAug *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorAug"];
}

@dynamic option;
@dynamic uuid;
@dynamic level;
@dynamic actor;
@dynamic grade;
@dynamic augInfo;

@end
