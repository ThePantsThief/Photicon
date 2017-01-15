//
//  PHPreferences.m
//  Photicon
//
//  Created by Tanner on 1/15/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "PHPreferences.h"

static NSString * const kPHPreferencesLocation = @"/var/mobile/Library/Preferences/io.c0ldra1n.photicon-prefs.plist";
static NSString * const kPHExtraPreferencesLocation = @"/var/mobile/Library/Preferences/io.c0ldra1n.photicon-prefs-extras.plist";


static NSDictionary * PHPreferences() {
    static NSDictionary *prefs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prefs = [NSDictionary dictionaryWithContentsOfFile:kPHPreferencesLocation] ?: @{};
    });
    
    return prefs;
}

static NSDictionary * ALBUM_PHPreferences() {
    static NSDictionary *prefs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prefs = [NSDictionary dictionaryWithContentsOfFile:kPHExtraPreferencesLocation] ?: @{};
    });
    
    return prefs;
}

static BOOL PHEnabled() {
    return [(PHPreferences()[@"PHEnabled"] ?: @YES) boolValue];
}

static NSString * PHImageEffect() {
    return PHPreferences()[@"PHImageEffect"] ?: @"none";
}

static double PHBlurAmount() {
    return [(PHPreferences()[@"PHBlurAmount"] ?: @70.0) doubleValue];
}

static NSString * PHAlbumName() {
    return PHPreferences()[@"PHAlbumName"] ?: @"Camera Roll";
}
