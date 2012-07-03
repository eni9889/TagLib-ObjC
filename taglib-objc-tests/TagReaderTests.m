//
//  TagReaderTests.m
//  TagLib-ObjC
//
//  Created by Me on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagReaderTests.h"

#import "TagReader.h"

#define TEST_TITLE @"test title èéÈ"
#define TEST_ARTIST @"test artist"
#define TEST_ALBUM @"test album èéÈ"
#define TEST_YEAR [NSNumber numberWithInteger:2040]
#define TEST_COMMENT @"Some strange comment œüªßƒ"
#define TEST_TRACK [NSNumber numberWithInteger:12345]
#define TEST_GENRE @"Test! èéÈ"

#define TEST_TITLE_2 @"ASDFGHJKL"
#define TEST_ARTIST_2 @"ttest artist"
#define TEST_ALBUM_2 @"ialbummmm"
#define TEST_YEAR_2 [NSNumber numberWithInteger:2080]
#define TEST_COMMENT_2 @"Ssfhdhgfghome strange dfgh \n œüªßƒ"
#define TEST_TRACK_2 [NSNumber numberWithInteger:7]
#define TEST_GENRE_2 @"uTest!"

@implementation TagReaderTests
- (void)saveTagReaderWithName:(NSString *)name extension:(NSString *)ext
{
    NSString *originalPath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:ext];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [[documentsDirectory stringByAppendingPathComponent:name] stringByAppendingPathExtension:ext];
    
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originalPath toPath:destinationPath error:&error];
    STAssertNil(error, @"Could not copy file from bundle");
    
    NSString *filePath = destinationPath;
    
    TagReader *t = [[TagReader alloc] initWithFileAtPath:filePath];
    STAssertNotNil(t, @"(1) Returned a nil TagReader");
    t.title = TEST_TITLE;
    t.artist = TEST_ARTIST;
    t.album = TEST_ALBUM;
    t.year = TEST_YEAR;
    t.comment = TEST_COMMENT;
    t.track = TEST_TRACK;
    t.genre = TEST_GENRE;
    STAssertTrue([t save], @"Save failed");
    
    
    t = [[TagReader alloc] initWithFileAtPath:filePath];
    STAssertNotNil(t, @"(2) Returned a nil TagReader");
    STAssertEqualObjects(t.title, TEST_TITLE, @"Title not equal");
    STAssertEqualObjects(t.artist, TEST_ARTIST, @"Artist not equal");
    STAssertEqualObjects(t.album, TEST_ALBUM, @"Album not equal");
    STAssertEqualObjects(t.year, TEST_YEAR, @"Title not equal");
    STAssertEqualObjects(t.comment, TEST_COMMENT, @"Comment not equal");
    STAssertEqualObjects(t.track, TEST_TRACK, @"Track not equal");
    STAssertEqualObjects(t.year, TEST_YEAR, @"Year not equal");
    STAssertEqualObjects(t.genre, TEST_GENRE, @"Genre not equal");
    
    t.title = TEST_TITLE_2;
    t.artist = TEST_ARTIST_2;
    t.album = TEST_ALBUM_2;
    t.year = TEST_YEAR_2;
    t.comment = TEST_COMMENT_2;
    t.track = TEST_TRACK_2;
    t.genre = TEST_GENRE_2;
    STAssertTrue([t save], @"Save failed");
    
    t = [[TagReader alloc] initWithFileAtPath:filePath];
    STAssertNotNil(t, @"(2) Returned a nil TagReader");
    STAssertEqualObjects(t.title, TEST_TITLE_2, @"Title not equal");
    STAssertEqualObjects(t.artist, TEST_ARTIST_2, @"Artist not equal");
    STAssertEqualObjects(t.album, TEST_ALBUM_2, @"Album not equal");
    STAssertEqualObjects(t.year, TEST_YEAR_2, @"Title not equal");
    STAssertEqualObjects(t.comment, TEST_COMMENT_2, @"Comment not equal");
    STAssertEqualObjects(t.track, TEST_TRACK_2, @"Track not equal");
    STAssertEqualObjects(t.year, TEST_YEAR_2, @"Year not equal");
    STAssertEqualObjects(t.genre, TEST_GENRE_2, @"Genre not equal");
}

- (void)testMusepack
{
    [self saveTagReaderWithName:@"click" extension:@"mpc"];
}

- (void)testASF
{
    [self saveTagReaderWithName:@"silence-1" extension:@"wma"];
}

- (void)testVorbis
{
    [self saveTagReaderWithName:@"empty" extension:@"ogg"];
}

- (void)testSpeex
{
    [self saveTagReaderWithName:@"empty" extension:@"spx"];
}

- (void)testFLAC
{
    [self saveTagReaderWithName:@"no-tags" extension:@"flac"];
}

- (void)testMP3
{
    [self saveTagReaderWithName:@"xing" extension:@"mp3"];
}

- (void)testTrueAudio
{
    [self saveTagReaderWithName:@"empty" extension:@"tta"];
}

- (void)testMP4_1
{
    [self saveTagReaderWithName:@"has-tags" extension:@"m4a"];
}

- (void)testMP4_2
{
    [self saveTagReaderWithName:@"no-tags" extension:@"m4a"];
}

- (void)testMP4_3
{
    [self saveTagReaderWithName:@"no-tags" extension:@"3g2"];
}

- (void)testAPE
{
    [self saveTagReaderWithName:@"mac-399" extension:@"ape"];
}

@end
