//
//  SR6Aug+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/03.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6AugProperties.h"

@implementation SR6Aug (CoreDataProperties)

+ (NSFetchRequest<SR6Aug *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Aug"];
}

@dynamic level;
@dynamic longDesc;
@dynamic maxLevel;
@dynamic name;
@dynamic reference;
@dynamic shortDesc;
@dynamic augUUID;
@dynamic optionName;
@dynamic category;
@dynamic essence;
@dynamic availNumber;
@dynamic availLetter;
@dynamic capacity;
@dynamic cost;
@dynamic essenceLevels;

@end
