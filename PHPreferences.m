//
//  PHPreferences.m
//  Photicon
//
//  Created by Tanner on 1/15/17.
//

#import "PHPreferences.h"

static NSString * const kPHPreferencesLocation = @"/var/mobile/Library/Preferences/io.c0ldra1n.photicon-prefs.plist";
static NSString * const kPHExtraPreferencesLocation = @"/var/mobile/Library/Preferences/io.c0ldra1n.photicon-prefs-extras.plist";

#define ONCE(...) static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        __VA_ARGS__ \
    });

NSDictionary * PHPreferences() {
    return [NSDictionary dictionaryWithContentsOfFile:kPHPreferencesLocation] ?: @{};
}

NSDictionary * ALBUM_PHPreferences() {
    return [NSDictionary dictionaryWithContentsOfFile:kPHExtraPreferencesLocation] ?: @{};
}

BOOL PHEnabled() {
    return [(PHPreferences()[@"PHEnabled"] ?: @YES) boolValue];
}

NSString * PHImageEffect() {
    return PHPreferences()[@"PHImageEffect"] ?: @"none";
}

double PHBlurAmount() {
    return [(PHPreferences()[@"PHBlurAmount"] ?: @70.0) doubleValue];
}

NSString * PHAlbumName() {
    return PHPreferences()[@"PHAlbumName"] ?: @"Camera Roll";
}

void PHSetPreferenceValueForKey(id value, NSString *key) {
    NSMutableDictionary *prefs = PHPreferences().mutableCopy;
    prefs[key] = value;
    [prefs writeToFile:kPHPreferencesLocation atomically:YES];
}

void PHSetAlbumPreferenceValueForKey(id value, NSString *key) {
    NSMutableDictionary *prefs = ALBUM_PHPreferences().mutableCopy;
    prefs[key] = value;
    [prefs writeToFile:kPHExtraPreferencesLocation atomically:YES];
}
