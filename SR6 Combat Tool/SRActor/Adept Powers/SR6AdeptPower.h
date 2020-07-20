//
//  SR6AdeptPower+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SR6AdeptPower : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * activationShortString;
@property (readonly) NSString * activationLongString;

@end

NS_ASSUME_NONNULL_END

#import "SR6AdeptPowerProperties.h"
