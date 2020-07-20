//
//  SR6Power+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SR6Power : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * categoryShortString;
@property (readonly) NSString * categoryLongString;
@property (readonly) NSString * actionShortString;
@property (readonly) NSString * actionLongString;
@property (readonly) NSString * rangeShortString;
@property (readonly) NSString * rangeLongString;
@property (readonly) NSString * typeShortString;
@property (readonly) NSString * typeLongString;
@property (readonly) NSString * durationShortString;
@property (readonly) NSString * durationLongString;

@end

NS_ASSUME_NONNULL_END

#import "SR6PowerProperties.h"
