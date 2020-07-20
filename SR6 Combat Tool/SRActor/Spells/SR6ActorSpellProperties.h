//
//  SR6ActorSpell+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/28.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorSpell.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorSpell (CoreDataProperties)

+ (NSFetchRequest<SR6ActorSpell *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSUUID *uuid;
@property (nullable, nonatomic, copy) NSString *option;
@property (nonatomic) int16_t numberHits;
@property (nonatomic) BOOL sustained;
@property (nullable, nonatomic, retain) SR6Actor *actor;
@property (nullable, nonatomic, retain) NSArray *spellInfo;

@end

NS_ASSUME_NONNULL_END
