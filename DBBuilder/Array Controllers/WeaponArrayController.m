//
//  WeaponArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/12.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "WeaponArrayController.h"
#import "SR6Weapon.h"

@implementation WeaponArrayController

-(IBAction)add:(id)sender {
    
    SR6Weapon *myWeapon= (SR6Weapon *)[self newObject];
    myWeapon.weaponUUID = [NSUUID UUID];
}

@end
