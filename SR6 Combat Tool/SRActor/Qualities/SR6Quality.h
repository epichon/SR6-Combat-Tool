//
//  SR6Quality+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/01.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SR6Quality : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * negativeShortString;
@property (readonly) NSString * negativeLongString;

@end

NS_ASSUME_NONNULL_END

#import "SR6QualityProperties.h"
