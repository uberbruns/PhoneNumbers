//
//  UBRRecord.h
//  UberNumbers
//
//  Created by Karsten Bruns on 10.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface UBRRecord : NSObject


- (void)applyFormattedNumber;


@property (strong) NSString * title;
@property (strong) NSString * currentPhoneNumber;
@property (strong) NSString * formattedPhoneNumber;
@property (strong, nonatomic) ABPerson * abPerson;
@property () NSUInteger phoneNumberIndex;

@end
