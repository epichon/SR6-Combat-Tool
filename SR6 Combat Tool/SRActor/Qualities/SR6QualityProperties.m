//
//  SR6Quality+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/01.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6QualityProperties.h"

// No enums for this one! Woot!

@implementation SR6Quality (CoreDataProperties)

+ (NSFetchRequest<SR6Quality *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Quality"];
}

@dynamic qualityUUID;
@dynamic karma;
@dynamic level;
@dynamic longDesc;
@dynamic maxLevel;
@dynamic name;
@dynamic optionName;
@dynamic reference;
@dynamic shortDesc;
@dynamic negative;

@end
