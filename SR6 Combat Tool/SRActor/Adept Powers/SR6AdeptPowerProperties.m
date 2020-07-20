//
//  SR6AdeptPower+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6AdeptPowerProperties.h"

@implementation SR6AdeptPower (CoreDataProperties)

+ (NSFetchRequest<SR6AdeptPower *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6AdeptPower"];
}

@dynamic cost;
@dynamic name;
@dynamic shortDesc;
@dynamic longDesc;
@dynamic optionName;
@dynamic maxLevel;
@dynamic activation;
@dynamic level;
@dynamic reference;
@dynamic adeptPowerUUID;

@end
