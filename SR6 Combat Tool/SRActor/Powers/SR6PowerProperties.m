//
//  SR6Power+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6PowerProperties.h"

@implementation SR6Power (CoreDataProperties)

+ (NSFetchRequest<SR6Power *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Power"];
}

@dynamic powerUUID;
@dynamic longDesc;
@dynamic name;
@dynamic reference;
@dynamic shortDesc;
@dynamic category;
@dynamic type;
@dynamic action;
@dynamic range;
@dynamic duration;
@dynamic optionName;

@end
