//
//  NSArray+Map.h
//  link
//
//  Created by toy on 20.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSArray (Map)

- (NSArray *)mapUsingBlock: (id (^)(id obj, NSUInteger idx))block;

@end
