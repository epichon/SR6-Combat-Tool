//
//  SR6ActorPower+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorComplexForm.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorComplexForm (CoreDataProperties)

+ (NSFetchRequest<SR6ActorComplexForm *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *option;
@property (nonatomic) int16_t numberHits;
@property (nonatomic) BOOL sustained;
@property (nullable, nonatomic, copy) NSUUID *uuid;
@property (nullable, nonatomic, retain) SR6Actor *actor;
@property (nullable, nonatomic, retain) NSArray *complexFormInfo;

@end

NS_ASSUME_NONNULL_END
