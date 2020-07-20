//
//  SR6Echo+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6EchoProperties.h"

@implementation SR6Echo (CoreDataProperties)

+ (NSFetchRequest<SR6Echo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Echo"];
}

@dynamic longDesc;
@dynamic echoUUID;
@dynamic name;
@dynamic reference;
@dynamic shortDesc;
@dynamic optionName;
@dynamic level;
@dynamic maxLevel;

@end
