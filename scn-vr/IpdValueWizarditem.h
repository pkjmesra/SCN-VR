//
//  IpdValueWizarditem.h
//  scn-vr
//
//  Created by Michael Fuller on 1/16/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "WizardItem.h"
#import "IpdWizardItem.h"

@interface IpdValueWizarditem : WizardItem

@property (assign, nonatomic) BOOL secondItem;

- (instancetype)initWith:(IpdWizardItem *) ipdWizardItem second:(BOOL) secondItem;

@end