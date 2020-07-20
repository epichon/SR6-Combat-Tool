//
//  SR6ComplexForm+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN


@interface SR6ComplexForm : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * durationShortString;
@property (readonly) NSString * durationLongString;

@end

NS_ASSUME_NONNULL_END

#import "SR6ComplexFormProperties.h"
