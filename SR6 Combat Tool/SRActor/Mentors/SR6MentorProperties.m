//
//  SR6Mentor+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6MentorProperties.h"

@implementation SR6Mentor (CoreDataProperties)

+ (NSFetchRequest<SR6Mentor *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6Mentor"];
}

@dynamic longDesc;
@dynamic mentorUUID;
@dynamic name;
@dynamic reference;
@dynamic shortDesc;
@dynamic similar;
@dynamic advantageAll;
@dynamic advantageMagician;
@dynamic advantageAdept;
@dynamic disadvantage;
@dynamic optionName;

@end
