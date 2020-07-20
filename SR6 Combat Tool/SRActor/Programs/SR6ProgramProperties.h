//
//  SR6Program+CoreDataProperties.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Program.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6Program (CoreDataProperties)

+ (NSFetchRequest<SR6Program *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSUUID *programUUID;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nonatomic) sr6ProgramCat category;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nonatomic) int16_t maxLevel;
@property (nonatomic) BOOL level;

@end

NS_ASSUME_NONNULL_END
