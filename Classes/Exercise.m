#import "Exercise.h"
#import "Result.h"

@interface Exercise ()
@end

@implementation Exercise {
    NSArray* _results;
}

- (NSString*)imageName {
    return self.identity;
}

- (void)addScore:(NSUInteger)score {
    [self.repository resultWithScore:score forExercise:self];
    _results = [self.repository findResultsForExercise:self];
    [self.repository asyncSave];
    //NSLog(@"Added score %ld",(long)score);
}

- (NSUInteger)latestScore {
    Result* result = [self.results lastObject];
    return result.score;
}

- (NSArray*)results {
    AssertNotNull(self.repository);
    if(_results == nil)
        _results = [self.repository findResultsForExercise:self];
    return _results;
}

- (CGFloat)average {
    int count = (int)MINVALUE(6, [self.results count]);
    CGFloat sum = 0;
    for(int i = 0; i < count; i++) {
        // TODO problematic code
        sum += [[self.results objectAtIndex:[self.results count] - count + i] score];
    }
    return roundf(sum / count);
}

- (NSString*)latestScoreDescription {
    if(self.latestScore == 0)
        return @"";
    return self.isEvaluation ? [NSString stringWithFormat:NSLocalizedString(@"Nivå N", nil), self.level] : [NSString stringWithFormat:NSLocalizedString(@"Poäng N", nil), self.latestScore];
}

- (NSUInteger)level {
    return (self.latestScore - 1) / 6 + 1;
}

@end
