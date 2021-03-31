#import <Foundation/Foundation.h>
#import "Repository.h"
#import "VideoItem.h"
#import "Technique.h"

@class Category;

@interface Exercise : Technique <VideoItem> {
}
@property(strong, nonatomic,  readonly) NSString* identity;
@property(nonatomic, strong) Repository* repository;
@property(nonatomic, assign) BOOL isEvaluation;
@property(nonatomic, assign, readonly) NSUInteger latestScore;
@property(strong, nonatomic, readonly) NSArray* results;
@property(nonatomic, assign, readonly) CGFloat average;
- (void)addScore:(NSUInteger)score;
- (NSString*)latestScoreDescription;
- (NSUInteger)level;
@end
