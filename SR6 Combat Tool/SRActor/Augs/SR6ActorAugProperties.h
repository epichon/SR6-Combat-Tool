//
//  SR6ActorPower+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorAug.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorAug (CoreDataProperties)

+ (NSFetchRequest<SR6ActorAug *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *option;
@property (nullable, nonatomic, copy) NSUUID *uuid;
@property (nonatomic) int16_t level;
@property (nonatomic) sr6AugGrade grade;
@property (nullable, nonatomic, retain) SR6Actor *actor;
@property (nullable, nonatomic, retain) NSArray *augInfo;

@end

NS_ASSUME_NONNULL_END
