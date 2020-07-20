//
//  SR6Program+CoreDataProperties.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ProgramProperties.h"

@implementation SR6Program (CoreDataProperties)

+ (NSFetchRequest<SR6Program *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Program"];
}

@dynamic programUUID;
@dynamic longDesc;
@dynamic name;
@dynamic reference;
@dynamic shortDesc;
@dynamic category;
@dynamic optionName;
@dynamic level;
@dynamic maxLevel;

@end
