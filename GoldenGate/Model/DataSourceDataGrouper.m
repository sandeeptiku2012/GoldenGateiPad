//
//  Created by Andreas Petrov on 9/28/12.
//  Copyright (c) 2012 Reaktor Magma. All rights reserved.
//


#import "DataSourceDataGrouper.h"
#import "PrefetchingDataSource.h"

@interface DataSourceDataGrouper()

@property (weak, nonatomic)     PrefetchingDataSource *dataSource;
@property (assign, nonatomic)   BOOL dataSourceHasChanged;

@end

@implementation DataSourceDataGrouper
{
    id <NSCopying> (* _groupingKeyFunction)(id);
}

- (id)initWithDataSource:(PrefetchingDataSource *)source groupingKeyFunction:(id <NSCopying> ( *)(id))groupingKeyFunction
{
    if ((self = [super init]))
    {
        _groupingKeyFunction = groupingKeyFunction;
        _dataSource = source;
        [_dataSource addObserver:self forKeyPath:@"dataDirty" options:NSKeyValueObservingOptionOld context:nil];
    }

    return self;
}

- (void)dealloc
{
    [_dataSource removeObserver:self forKeyPath:@"dataDirty"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.dataSourceHasChanged = YES;
}

- (void)createGroupedData
{
    NSMutableDictionary *alfabetizedChannelDict = [NSMutableDictionary new];
    
    for (NSUInteger i = 0; i < self.dataSource.cachedTotalItemCount ; ++i)
    {
        NSObject *object = [self.dataSource objectAtIndex:i];
        id<NSCopying> objectKey = _groupingKeyFunction(object);
        if (objectKey)
        {
            NSMutableArray *objectArray = [alfabetizedChannelDict objectForKey:objectKey];
            if (objectArray == nil)
            {
                objectArray = [NSMutableArray new];
                [alfabetizedChannelDict setObject:objectArray forKey:objectKey];
            }
            
            [objectArray addObject:object];
        }
    }
    
    _groupedDataKeys = [[alfabetizedChannelDict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    _groupedData     = [alfabetizedChannelDict objectsForKeys: _groupedDataKeys notFoundMarker: [NSNull null]];
}

#pragma mark - Properties

- (NSArray *)groupedData
{
    if (self.dataSourceHasChanged || _groupedData == nil)
    {
        [self createGroupedData];
    }

    return _groupedData;
}

- (NSArray *)groupedDataKeys
{
    if (self.dataSourceHasChanged || _groupedDataKeys == nil)
    {
        [self createGroupedData];
    }

    return _groupedDataKeys;
}

@end