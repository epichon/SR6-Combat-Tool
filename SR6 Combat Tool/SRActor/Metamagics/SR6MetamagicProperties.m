//
//  SR6Metamagic+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6MetamagicProperties.h"

@implementation SR6Metamagic (CoreDataProperties)

+ (NSFetchRequest<SR6Metamagic *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Metamagic"];
}

@dynamic longDesc;
@dynamic name;
@dynamic metamagicUUID;
@dynamic reference;
@dynamic shortDesc;
@dynamic optionName;
@dynamic level;
@dynamic maxLevel;

@end
