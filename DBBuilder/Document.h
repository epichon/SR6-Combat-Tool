//
//  Document.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SpellArrayController;

@interface Document : NSPersistentDocument {
}

@property (readwrite, strong) NSArray * _Nonnull spellCategories;
@property (readwrite, strong) NSArray * _Nonnull powerTypes;
@property (readwrite, strong) NSArray * _Nonnull durations;
@property (readwrite, strong) NSArray * _Nonnull spellRanges;
@property (readwrite,strong) NSArray * _Nonnull spellDamages;
@property (readwrite, strong) NSArray * _Nonnull activations;
@property (readwrite, strong) NSArray * _Nonnull powerCategories;
@property (readwrite, strong) NSArray * _Nonnull augCategories;
@property (readwrite, strong) NSArray * _Nonnull availLetters;
@property (readwrite, strong) NSArray * _Nonnull programCategories;
@property (readwrite, strong) NSArray * _Nonnull weaponCategories;
@property (readwrite, strong) NSArray * _Nonnull weaponAmmoCategories;
@property (readwrite, strong) NSArray * _Nonnull weaponDamageCategories;
@property (readwrite, strong) NSArray * _Nonnull skillsList;

@end
