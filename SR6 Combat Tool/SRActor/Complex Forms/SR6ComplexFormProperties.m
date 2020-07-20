//
//  SR6ComplexForm+CoreDataProperties.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ComplexFormProperties.h"

@implementation SR6ComplexForm (CoreDataProperties)

+ (NSFetchRequest<SR6ComplexForm *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SR6ComplexForm"];
}

@dynamic fade;
@dynamic crackingTest;
@dynamic duration;
@dynamic longDesc;
@dynamic name;
@dynamic optionName;
@dynamic reference;
@dynamic shortDesc;
@dynamic complexFormUUID;

@end
