//
//  SR6ActorPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorComplexFormProperties.h"

@implementation SR6ActorComplexForm (CoreDataProperties)

+ (NSFetchRequest<SR6ActorComplexForm *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ActorComplexForm"];
}

@dynamic option;
@dynamic numberHits;
@dynamic sustained;
@dynamic uuid;
@dynamic actor;
@dynamic complexFormInfo;

@end
