//
//  SR6Program+CoreDataClass.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6Program : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * categoryShortString;
@property (readonly) NSString * categoryLongString;

@end

NS_ASSUME_NONNULL_END

#import "SR6ProgramProperties.h"
