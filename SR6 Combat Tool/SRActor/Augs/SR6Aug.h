//
//  SR6Aug+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/03.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6Aug : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * categoryShortString;
@property (readonly) NSString * categoryLongString;
@property (readonly) NSString * availLetterShortString;
@property (readonly) NSString * availLetterLongString;
@property (readonly) NSString * availFullString;

@end

NS_ASSUME_NONNULL_END

#import "SR6AugProperties.h"
