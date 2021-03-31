#import <Foundation/Foundation.h>

@class Repository;


@interface CategorySelectorView : UIView
@property(nonatomic, weak) id delegate;
@property(nonatomic, retain) Repository* repository;
@end