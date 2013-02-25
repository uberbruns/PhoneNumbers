//
//  UBRAppDelegate.m
//  Uber Numbers
//
//  Created by Karsten Bruns on 10.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#define COUNTRY_CODES @[@"AC", @"AD", @"AE", @"AF", @"AG", @"AI", @"AL", @"AM", @"AO", @"AR", @"AS", @"AT", @"AU", @"AW", @"AX", @"AZ", @"BA", @"BB", @"BD", @"BE", @"BF", @"BG", @"BH", @"BI", @"BJ", @"BL", @"BM", @"BN", @"BO", @"BQ", @"BR", @"BS", @"BT", @"BW", @"BY", @"BZ", @"CA", @"CC", @"CD", @"CF", @"CG", @"CH", @"CI", @"CK", @"CL", @"CM", @"CN", @"CO", @"CR", @"CU", @"CV", @"CW", @"CX", @"CY", @"CZ", @"DE", @"DJ", @"DK", @"DM", @"DO", @"DZ", @"EC", @"EE", @"EG", @"EH", @"ER", @"ES", @"ET", @"FI", @"FJ", @"FK", @"FM", @"FO", @"FR", @"GA", @"GB", @"GD", @"GE", @"GF", @"GG", @"GH", @"GI", @"GL", @"GM", @"GN", @"GP", @"GQ", @"GR", @"GT", @"GU", @"GW", @"GY", @"HK", @"HN", @"HR", @"HT", @"HU", @"ID", @"IE", @"IL", @"IM", @"IN", @"IO", @"IQ", @"IR", @"IS", @"IT", @"JE", @"JM", @"JO", @"JP", @"KE", @"KG", @"KH", @"KI", @"KM", @"KN", @"KP", @"KR", @"KW", @"KY", @"KZ", @"LA", @"LB", @"LC", @"LI", @"LK", @"LR", @"LS", @"LT", @"LU", @"LV", @"LY", @"MA", @"MC", @"MD", @"ME", @"MF", @"MG", @"MH", @"MK", @"ML", @"MM", @"MN", @"MO", @"MP", @"MQ", @"MR", @"MS", @"MT", @"MU", @"MV", @"MW", @"MX", @"MY", @"MZ", @"NA", @"NC", @"NE", @"NF", @"NG", @"NI", @"NL", @"NO", @"NP", @"NR", @"NU", @"NZ", @"OM", @"PA", @"PE", @"PF", @"PG", @"PH", @"PK", @"PL", @"PM", @"PR", @"PS", @"PT", @"PW", @"PY", @"QA", @"RE", @"RO", @"RS", @"RU", @"RW", @"SA", @"SB", @"SC", @"SD", @"SE", @"SG", @"SH", @"SI", @"SJ", @"SK", @"SL", @"SM", @"SN", @"SO", @"SR", @"SS", @"ST", @"SV", @"SX", @"SY", @"SZ", @"TC", @"TD", @"TG", @"TH", @"TJ", @"TK", @"TL", @"TM", @"TN", @"TO", @"TR", @"TT", @"TV", @"TW", @"TZ", @"UA", @"UG", @"US", @"UY", @"UZ", @"VA", @"VC", @"VE", @"VG", @"VI", @"VN", @"VU", @"WF", @"WS", @"YE", @"YT", @"ZA", @"ZM", @"ZW"]


#import "UBRAppDelegate.h"
#import "UBRRecord.h"
#import "UBRPhoneNumberTaskController.h"
#import <AddressBook/AddressBook.h>


@interface UBRAppDelegate () {
    UBRPhoneNumberTaskController * _libTaskController;
    NSMutableArray * _records;
    NSArray * _countryCodes;
}

- (NSMutableArray *)records;
- (void)update;

@end



@implementation UBRAppDelegate



#pragma mark - App Delegate -

- (id)init {
    
    self = [super init];
    if (self) {
		
		// Init Instance Variables
        _records = nil;
        _libTaskController = [[UBRPhoneNumberTaskController alloc] init];
        _countryCodes = COUNTRY_CODES;
        
		// Set Default Country Code
		NSString * localCountryCode = [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] uppercaseString];
		if ([_countryCodes indexOfObject:localCountryCode] != NSNotFound) {
			self.selectedCountryCode = [_countryCodes indexOfObject:localCountryCode];
		} else {
			self.selectedCountryCode = [_countryCodes indexOfObject:@"US"];
		}
		
    }
    return self;
    
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}




#pragma mark - Records Controller -

- (NSMutableArray *)records {

    if (_records == nil) {
        
        NSArray * people = [[ABAddressBook sharedAddressBook] people];
        _records = [[NSMutableArray alloc] init];
        

        for (ABPerson * person in people) {
            
            ABMultiValue * phoneNumbers = [person valueForProperty:@"Phone"];
            
            if (phoneNumbers && [phoneNumbers isKindOfClass:[ABMultiValue class]]) {
                
                for (NSUInteger i = 0; i < [phoneNumbers count]; i++) {
                    
                    NSString * phoneNumber = [NSString stringWithFormat:@"%@", [phoneNumbers valueAtIndex:i]];
					
                    BOOL added = [_libTaskController addPhoneNumber:phoneNumber country:[_countryCodes objectAtIndex:self.selectedCountryCode]];
					
					if (added) {

						UBRRecord * record = [[UBRRecord alloc] init];
						record.currentPhoneNumber = phoneNumber;
						record.abPerson = person;
						record.phoneNumberIndex = i;
						[_records addObject:record];
					
					}

                }
                
            }
                        
        }
        
        NSArray * formattedPhoneNumbers = [_libTaskController processPhoneNumbers];
        
        for (NSUInteger i = 0; i < MIN(_records.count, formattedPhoneNumbers.count) ; i++) {
            NSString * formattedPhoneNumber = [formattedPhoneNumbers objectAtIndex:i];
            UBRRecord * record = [_records objectAtIndex:i];
            record.formattedPhoneNumber = formattedPhoneNumber;
        }
        
    }
    
    [_records sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:TRUE]]];
    
    return _records;

}



- (void)update {

    _records = nil;
    [_recordTableView deselectAll:nil];
    [_recordTableView reloadData];

}




#pragma mark - Interface Actions -

- (IBAction)updateSelectedRecords:(id)sender {

    [[_recordTableView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < _records.count) {
            [[_records objectAtIndex:idx] applyFormattedNumber];
        }
    }];
    
    [[ABAddressBook sharedAddressBook] save];
    [self update];
    
}



- (IBAction)updateSettings:(id)sender {

    [self update];
    
}



- (IBAction)reloadRecords:(id)sender {

    [self update];

}




#pragma mark - Table View Data Source -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.records.count;

}



- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    if (row >= self.records.count) {
        return @"";
    }
    
    UBRRecord * record = [self.records objectAtIndex:row];
    
    if ([tableColumn.identifier isEqualToString:@"title"]) {
        return record.title;        
    } else if ([tableColumn.identifier isEqualToString:@"currentPhoneNumber"]) {
        return record.currentPhoneNumber;
    } else if ([tableColumn.identifier isEqualToString:@"formattedPhoneNumber"]) {
        return record.formattedPhoneNumber;
    } else {
        return @"";
    }
    
}




#pragma mark - Window Delegate -

- (void) windowWillClose:(NSNotification *)notification {

    [[NSApplication sharedApplication] terminate:nil];

}

@end
