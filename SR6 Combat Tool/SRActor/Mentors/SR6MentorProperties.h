//
//  SR6Mentor+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Mentor.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6Mentor (CoreDataProperties)

+ (NSFetchRequest<SR6Mentor *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSUUID *mentorUUID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSString *similar;
@property (nullable, nonatomic, copy) NSString *advantageAll;
@property (nullable, nonatomic, copy) NSString *advantageMagician;
@property (nullable, nonatomic, copy) NSString *advantageAdept;
@property (nullable, nonatomic, copy) NSString *disadvantage;
@property (nullable, nonatomic, copy) NSString *optionName;

@end

NS_ASSUME_NONNULL_END
