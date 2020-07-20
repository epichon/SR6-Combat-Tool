//
//  SR6ActorQuality+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorAdeptPower.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorAdeptPower (CoreDataProperties)

+ (NSFetchRequest<SR6ActorAdeptPower *> *)fetchRequest;

@property (nonatomic) int16_t level;
@property (nullable, nonatomic, copy) NSString *option;
@property (nullable, nonatomic, copy) NSUUID *uuid;
@property (nullable, nonatomic, retain) SR6Actor *actor;
@property (nullable, nonatomic, retain) NSArray *adeptPowerInfo;

@end

NS_ASSUME_NONNULL_END
