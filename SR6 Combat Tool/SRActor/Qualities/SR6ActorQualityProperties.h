//
//  SR6ActorSpell+CoreDataProperties.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorQuality.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorQuality (CoreDataProperties)

+ (NSFetchRequest<SR6ActorQuality *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *option;
@property (nullable, nonatomic, copy) NSUUID *uuid;
@property (nonatomic) int16_t level;
@property (nullable, nonatomic, retain) SR6Actor *actor;
@property (nullable, nonatomic, retain) NSArray *qualityInfo;

@end

NS_ASSUME_NONNULL_END
