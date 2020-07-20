//
//  SR6ActorPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorPowerProperties.h"

@implementation SR6ActorPower (CoreDataProperties)

+ (NSFetchRequest<SR6ActorPower *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorPower"];
}

@dynamic option;
@dynamic uuid;
@dynamic actor;
@dynamic powerInfo;

@end
