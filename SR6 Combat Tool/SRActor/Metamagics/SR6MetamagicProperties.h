//
//  SR6Metamagic+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Metamagic.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6Metamagic (CoreDataProperties)

+ (NSFetchRequest<SR6Metamagic *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSUUID *metamagicUUID;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nonatomic) BOOL level;
@property (nonatomic) int16_t maxLevel;

@end

NS_ASSUME_NONNULL_END
