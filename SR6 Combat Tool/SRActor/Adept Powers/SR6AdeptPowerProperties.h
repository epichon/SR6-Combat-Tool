//
//  SR6AdeptPower+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <CoreData/CoreData.h>
#import "SR6AdeptPower.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6AdeptPower (CoreDataProperties)

+ (NSFetchRequest<SR6AdeptPower *> *)fetchRequest;

@property (nonatomic) BOOL level;
@property (nonatomic) sr6Activation activation;
@property (nullable, nonatomic, copy) NSDecimalNumber *cost;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, retain) NSObject *maxLevel;
@property (nullable, nonatomic, copy) NSUUID *adeptPowerUUID;

@end

NS_ASSUME_NONNULL_END
