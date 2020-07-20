//
//  SR6ActorPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorEchoProperties.h"

@implementation SR6ActorEcho (CoreDataProperties)

+ (NSFetchRequest<SR6ActorEcho *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorEcho"];
}

@dynamic level;
@dynamic option;
@dynamic uuid;
@dynamic actor;
@dynamic echoInfo;

@end
