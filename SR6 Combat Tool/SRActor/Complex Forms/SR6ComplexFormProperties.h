//
//  SR6ComplexForm+CoreDataProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ComplexForm.h"


NS_ASSUME_NONNULL_BEGIN

@interface SR6ComplexForm (CoreDataProperties)

+ (NSFetchRequest<SR6ComplexForm *> *)fetchRequest;

@property (nonatomic) int16_t fade;
@property (nonatomic) BOOL crackingTest;
@property (nonatomic) sr6Duration duration;
@property (nullable, nonatomic, copy) NSString *longDesc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *optionName;
@property (nullable, nonatomic, copy) NSString *reference;
@property (nullable, nonatomic, copy) NSString *shortDesc;
@property (nullable, nonatomic, copy) NSUUID *complexFormUUID;

@end

NS_ASSUME_NONNULL_END
