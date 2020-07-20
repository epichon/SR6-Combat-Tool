//
//  SR6Aug+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/03.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Aug.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6Aug (CoreDataProperties)

+ (NSFetchRequest<SR6Aug *> *)fetchRequest;

@property (nonatomic) BOOL level;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nonatomic) int16_t maxLevel;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSUUID *augUUID;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nonatomic) sr6AugCategory category;
@property (nullable, nonatomic, copy) NSDecimalNumber *essence;
@property (nonatomic) int16_t availNumber;
@property (nonatomic) sr6AvailLetter availLetter;
@property (nonatomic) int16_t capacity;
@property (nonatomic) int32_t cost;
@property (nonatomic) BOOL essenceLevels;

@end

NS_ASSUME_NONNULL_END
