//
//  SR6ActorPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorProgramProperties.h"

@implementation SR6ActorProgram (CoreDataProperties)

+ (NSFetchRequest<SR6ActorProgram *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorProgram"];
}

@dynamic option;
@dynamic uuid;
@dynamic actor;
@dynamic level;
@dynamic programInfo;
@dynamic loaded;

@end
