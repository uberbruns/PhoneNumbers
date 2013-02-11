//
//  UBRAppDelegate.h
//  Uber Numbers
//
//  Created by Karsten Bruns on 10.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UBRAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *recordTableView;
@property (weak) IBOutlet NSPopUpButton *countryCodePullDown;
@property (readonly) NSArray * countryCodes;
@property () NSUInteger selectedCountryCode;

- (IBAction)updateSelectedRecords:(id)sender;
- (IBAction)updateSettings:(id)sender;
- (IBAction)reloadRecords:(id)sender;

@end
