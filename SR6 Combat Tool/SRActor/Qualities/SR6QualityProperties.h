//
//  SR6Quality+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/01.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Quality.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6Quality (CoreDataProperties)

+ (NSFetchRequest<SR6Quality *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSUUID *qualityUUID;
@property (nonatomic) int16_t karma;
@property (nonatomic) BOOL level;
@property (nonatomic) int16_t maxLevel;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nonatomic) BOOL negative;

@end

NS_ASSUME_NONNULL_END
