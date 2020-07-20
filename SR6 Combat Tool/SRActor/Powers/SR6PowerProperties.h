//
//  SR6Power+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//


#import "SR6Power.h"
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6Power (CoreDataProperties)

+ (NSFetchRequest<SR6Power *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSUUID *powerUUID;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nonatomic) sr6PowerCategory category;
@property (nonatomic) sr6PowerType type;
@property (nonatomic) sr6Activation action;
@property (nonatomic) sr6Range range;
@property (nonatomic) sr6Duration duration;
@property (nullable, nonatomic, copy) NSString *optionName;

@end

NS_ASSUME_NONNULL_END
