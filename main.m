//
//  main.m
//  link
//
//  Created by toy on 19.12.10.
//  Copyright 2010 Ivan Kuchin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "FNGlue.h"
#import "NSArray+Map.h"

NSArray* finderSelectionPaths(){
	FNApplication *finder = [FNApplication applicationWithName: @"Finder"];
	NSArray *references = [[finder selection] getItem];
	NSArray *paths = [references mapUsingBlock:^(id obj, NSUInteger idx) {
		NSString *url = [[[(FNReference *)obj URL] get] send];
		return (id)[[NSURL URLWithString:url] path];
	}];
	return paths;
}

int main(int argc, char *argv[]) {
	id pool = [[NSAutoreleasePool alloc] init];

	NSFileManager *fileManager = [[NSFileManager alloc] init];

	[finderSelectionPaths() enumerateObjectsUsingBlock:^(id src, NSUInteger idx, BOOL *stop) {
		NSString *ext, *srcWOExt, *dst;
		BOOL isDir;
		BOOL forceSymlink = 0 != (kCGEventFlagMaskAlternate & CGEventSourceFlagsState(kCGEventSourceStateCombinedSessionState));

		ext = [src pathExtension];
		srcWOExt = [src stringByDeletingPathExtension];

		if ([fileManager fileExistsAtPath:src isDirectory:&isDir]) {
			for (int i = 1; ; i++) {
				dst = [NSString stringWithFormat:@"%@ %d", srcWOExt, i];
				if ([ext length] > 0) {
					dst = [dst stringByAppendingPathExtension:ext];
				}
				if (![fileManager fileExistsAtPath:dst]) {
					if (isDir || forceSymlink) {
						[fileManager createSymbolicLinkAtPath:dst withDestinationPath:src error:nil];
					} else {
						[fileManager linkItemAtPath:src toPath:dst error:nil];
					}
					break;
				}
			}
		}
	}];

	[pool release];
	return 0;
}

