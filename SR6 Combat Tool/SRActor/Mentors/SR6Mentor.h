//
//  SR6Mentor+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SR6Mentor : NSManagedObject

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;

@end

NS_ASSUME_NONNULL_END

#import "SR6MentorProperties.h"
