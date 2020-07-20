//
//  SR6ActorQuality+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorAdeptPowerProperties.h"

@implementation SR6ActorAdeptPower (CoreDataProperties)

+ (NSFetchRequest<SR6ActorAdeptPower *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorAdeptPower"];
}

@dynamic level;
@dynamic option;
@dynamic uuid;
@dynamic actor;
@dynamic adeptPowerInfo;

@end
