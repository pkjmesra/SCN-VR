//
//  VirtualCustomWizardItem.m
//  scn-vr
//
//  Created by Michael Fuller on 1/19/15.
//  Copyright (c) 2015 M-Gate Labs. All rights reserved.
//

#import "VirtualCustomWizardItem.h"
#import "Constants.h"

@implementation VirtualCustomWizardItem

- (instancetype)initWithVirtual:(VirtualDeviceWizardItem *) virtualWizard physical:(PhysicalDeviceWizardItem *) physicalWizard mode:(int) mode
{
    self = [super initWith: (mode == 0 ? @"Width (MM)" : @"Height (MM)")  info:(mode == 0 ? @"Device Width in MM" : @"Device Height in MM") itemId:(mode == 0 ? WIZARD_ITEM_VIRTUAL_DEVICE_WIDTH : WIZARD_ITEM_VIRTUAL_DEVICE_HEIGHT) type:WizardItemDataTypeInt];
    if (self) {
        _physicalWizard = physicalWizard;
        _virtualWizard = virtualWizard;
        _mode = mode;
        self.count = 0;
        self.valueId = @"";
        self.valueIndex = 0;
    }
    return self;
}

-(void) chainUpdated {
    if ([_virtualWizard ready]) {
        
        if (_virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom || _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypePortraitCustom) {
            int maxIndex;
            
            if (_mode == 0) {
                maxIndex = _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom ? _physicalWizard.selected.widthMM : _physicalWizard.selected.heightMM;
            } else if (_mode == 1) {
                maxIndex = _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom ? _physicalWizard.selected.heightMM : _physicalWizard.selected.widthMM;
            }
            
            self.count = maxIndex - 1;
            if (self.valueIndex >= self.count) {
                self.valueIndex = self.count - 1;
                self.valueId = [self stringForIndex:self.valueIndex];
            }
        } else {
            self.count = 1;
            self.valueIndex = 0;
            self.valueId = [self stringForIndex:0];
        }
    } else {
        self.count = 1;
        self.valueIndex = 0;
        self.valueId = [self stringForIndex:0];
    }
}

-(void) selectedIndex:(int) index {
    self.valueIndex = index;
    self.valueId = [self stringForIndex:index];
}

-(void) loadForInt:(int) value {
    self.valueIndex = value;
    self.valueId = [self stringForIndex:value];
}

-(BOOL) available {
    return _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypePortraitCustom || _virtualWizard.virtualDevice.type == VirtualDeviceConfigurationTypeLandscapeCustom;
}

-(BOOL) ready {
    return self.count > 1;
}

-(NSString *) stringForIndex:(int) index {
    return [NSString stringWithFormat:@"%d MM", index + 1];
}

-(void) updateProfileInstance:(ProfileInstance *) instance {
    
    if (_mode == 0) {
        instance.virtualWidthMM = self.valueIndex + 1;
    } else {
        instance.virtualHeightMM = self.valueIndex + 1;
    
    
        switch (_virtualWizard.virtualDevice.type) {
            case VirtualDeviceConfigurationTypeLandscapeCustom: {
                
                instance.landscapeView = YES;
                
                // Need to go from MM to MM
                
                float targetWidthMM = instance.virtualWidthMM;
                float targetHeightMM = instance.virtualHeightMM;
                
                // GO from MM to Inches
                float targetWidthIN = targetWidthMM / IN_2_MM;
                float targetHeightIN = targetHeightMM / IN_2_MM;
                
                instance.virtualWidthPX = targetWidthIN * instance.physicalDPI;
                instance.virtualHeightPX = targetHeightIN * instance.physicalDPI;
                
                // May be overkill
                instance.virtualWidthIN = instance.virtualWidthPX / instance.physicalDPI;
                instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
                
                instance.virtualWidthMM = instance.virtualWidthIN * IN_2_MM;
                instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
                
                instance.virtualOffsetLeft = (instance.physicalWidthPX - instance.virtualWidthPX) / 2;
                instance.virtualOffsetBottom = (instance.physicalHeightPX - instance.virtualHeightPX) / 2;
                
            } break;
            case VirtualDeviceConfigurationTypePortraitCustom: {
                
                instance.landscapeView = NO;
                
                float targetWidthMM = instance.virtualWidthMM;
                float targetHeightMM = instance.virtualHeightMM;
                
                // GO from MM to Inches
                float targetWidthIN = targetWidthMM / IN_2_MM;
                float targetHeightIN = targetHeightMM / IN_2_MM;
                
                instance.virtualWidthPX = targetWidthIN * instance.physicalDPI;
                instance.virtualHeightPX = targetHeightIN * instance.physicalDPI;
                
                instance.virtualWidthIN = instance.virtualWidthPX / instance.physicalDPI;
                instance.virtualHeightIN = instance.virtualHeightPX / instance.physicalDPI;
                
                instance.virtualWidthMM = instance.virtualWidthIN * IN_2_MM;
                instance.virtualHeightMM = instance.virtualHeightIN * IN_2_MM;
                
                instance.virtualOffsetLeft = (instance.physicalHeightPX / 2) - (instance.virtualWidthPX /2);
                instance.virtualOffsetBottom = (instance.physicalWidthPX / 2) - (instance.virtualHeightPX / 2);
                
            } break;
            default: {
                
            } break;
        }
    }
}

-(WizardItemNotReadyAction) notReadyAction {
    return WizardItemNotReadyActionContinue;
}

@end