//
//  BFFConstants.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/19/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFFConstants : NSObject
//KEYS FOR TRANSACTION DICIONTARY
extern NSString* const isLentKey;
extern NSString* const amountKey;
extern NSString* const itemNameKey;
extern NSString* const userIDKey;
extern NSString* const userFirstKey;
extern NSString* const userNameKey;
extern NSString* const profilePictureDataKey;
//KEYS FOR NSUSERDEFAULTS
extern NSString* const transactionArrayKey;
@end
