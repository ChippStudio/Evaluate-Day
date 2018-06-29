//
//  Themes.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RxSwift

final class Themes: NSObject {
    
    // MARK: - Singleton
    static let manager = Themes()

    // MARK: - Variable
    var all = [Theme]()
    var changeTheme = Variable(false)
    var currentTheme: Theme? {
        for t in self.all {
            if t.type == self.current {
                return t
            }
        }
        
        return nil
    }
    var current: ThemeType! {
        set {
            try! Database.manager.app.write {
                Database.manager.application.settings.theme = newValue
            }
            self.changeTheme.value = true
        }
        get {
            return Database.manager.application.settings.theme
        }
    }
    
    // MARK: - Init
    private override init() {
        super.init()
        self.setThemes()
    }
    
    // MARK: - Private func
    private func setThemes() {
        self.all.removeAll()
        self.all.append(Theme(previewImage: #imageLiteral(resourceName: "light"), type: .light, iconName: nil))
        self.all.append(Theme(previewImage: #imageLiteral(resourceName: "dark"), type: .dark, iconName: "DarkAppIcon"))
        self.all.append(Theme(previewImage: #imageLiteral(resourceName: "orange"), type: .orange, iconName: "OrangeAppIcon"))
        self.all.append(Theme(previewImage: #imageLiteral(resourceName: "black"), type: .black, iconName: "BlackAppIcon"))
    }
    
    // MARK: - Styles
    // Get styles for specific view controller
    var tabControlerStyle: TabControllerStyle {
        if self.current == .light {
            return LightTabControllerTheme()
        } else if self.current == .dark {
            return DarkTabControllerTheme()
        } else if self.current == .orange {
            return OrangeTabControllerTheme()
        } else if self.current == .black {
            return BlackTabControllerTheme()
        }
        
        return LightTabControllerTheme()
    }
    var activityControlerStyle: ActivityControllerStyle {
        if self.current == .light {
            return LightActivityControllerTheme()
        } else if self.current == .dark {
            return DarkActivityControllerTheme()
        } else if self.current == .orange {
            return OrangeActivityControllerTheme()
        } else if self.current == .black {
            return BlackActivityControllerTheme()
        }
        
        return LightActivityControllerTheme()
    }
    var evaluateStyle: EvaluableStyle {
        if self.current == .light {
            return LightEvaluateTheme()
        } else if self.current == .dark {
            return DarkEvaluateTheme()
        } else if self.current == .orange {
            return OrangeEvaluateTheme()
        } else if self.current == .black {
            return BlackEvaluateTheme()
        }
        
        return LightEvaluateTheme()
    }
    
    var analyticalStyle: AnalyticalStyle {
        if self.current == .light {
            return LightAnalyticalTheme()
        } else if self.current == .dark {
            return DarkAnalyticalTheme()
        } else if self.current == .orange {
            return OrangeAnalyticalTheme()
        } else if self.current == .black {
            return BlackAnalyticalTheme()
        }
        
        return LightAnalyticalTheme()
    }
    
    var newCardStyle: NewCardStyle {
        if self.current == .light {
            return LightNewCardTheme()
        } else if self.current == .dark {
            return DarkNewCardTheme()
        } else if self.current == .orange {
            return OrangeNewCardTheme()
        } else if self.current == .black {
            return BlackNewCardTheme()
        }
        
        return LightNewCardTheme()
    }
    
    var cardSettingsStyle: CardSettingsStyle {
        if self.current == .light {
            return LightCardSettingsTheme()
        } else if self.current == .dark {
            return DarkCardSettingsTheme()
        } else if self.current == .orange {
            return OrangeCardSettingsTheme()
        } else if self.current == .black {
            return BlackCardSettingsTheme()
        }
        
        return LightCardSettingsTheme()
    }
    
    var cardMergeStyle: CardMergeStyle {
        if self.current == .light {
            return LightCardMergeTheme()
        } else if self.current == .dark {
            return DarkCardMergeTheme()
        } else if self.current == .orange {
            return OrangeCardMergeTheme()
        } else if self.current == .black {
            return BlackCardMergeTheme()
        }
        
        return LightCardMergeTheme()
    }
    
    var settingsStyle: SettingsStyle {
        if self.current == .light {
            return LightSettingsTheme()
        } else if self.current == .dark {
            return DarkSettingsTheme()
        } else if self.current == .orange {
            return OrangeSettingsTheme()
        } else if self.current == .black {
            return BlackSettingsTheme()
        }
        
        return LightSettingsTheme()
    }
    var topViewControllerStyle: TopViewControllerStyle {
        if self.current == .light {
            return LightTopControllerTheme()
        } else if self.current == .dark {
            return DarkTopControllerTheme()
        } else if self.current == .orange {
            return OrangeTopControllerTheme()
        } else if self.current == .black {
            return BlackTopControllerTheme()
        }
        
        return LightTopControllerTheme()
    }
    
    var bottomViewControllerStyle: BottomViewControllerStyle {
        if self.current == .light {
            return LightBottomControllerTheme()
        } else if self.current == .dark {
            return DarkBottomControllerTheme()
        } else if self.current == .orange {
            return OrangeBottomControllerTheme()
        } else if self.current == .black {
            return BlackBottomControllerTheme()
        }
        
        return LightBottomControllerTheme()
    }
    
    var passcodeControllerStyle: PasscodeStyle {
        if self.current == .light {
            return LightPasscodeControllerTheme()
        } else if self.current == .dark {
            return DarkPasscodeControllerTheme()
        } else if self.current == .orange {
            return OrangePasscodeControllerTheme()
        } else if self.current == .black {
            return BlackPasscodeControllerTheme()
        }
        
        return LightPasscodeControllerTheme()
    }
    
    var shareViewStyle: ShareViewStyle {
        if self.current == .light {
            return LightShareViewTheme()
        } else if self.current == .dark {
            return DarkShareViewTheme()
        } else if self.current == .orange {
            return OrangeShareViewTheme()
        } else if self.current == .black {
            return BlackShareViewTheme()
        }
        
        return LightShareViewTheme()
    }
    
    var slidesControllerStyle: SlidesViewControllerStyle {
        if self.current == .light {
            return LightSlidesControllerTheme()
        } else if self.current == .dark {
            return DarkSlidesControllerTheme()
        } else if self.current == .orange {
            return OrangeSlidesControllerTheme()
        } else if self.current == .black {
            return BlackSlidesControllerTheme()
        }
        
        return LightSlidesControllerTheme()
    }
    var mapControllerStyle: MapViewControllerStyle {
        if self.current == .light {
            return LightMapControllerTheme()
        } else if self.current == .dark {
            return DarkMapControllerTheme()
        } else if self.current == .orange {
            return OrangeMapControllerTheme()
        } else if self.current == .black {
            return BlackMapControllerTheme()
        }
        
        return LightMapControllerTheme()
    }
    
    var entryControllerStyle: EntryViewControllerStyle {
        if self.current == .light {
            return LightEntryViewControllerTheme()
        } else if self.current == .dark {
            return DarkEntryViewControllerTheme()
        } else if self.current == .orange {
            return OrangeEntryViewControllerTheme()
        } else if self.current == .black {
            return BlackEntryViewControllerTheme()
        }
        
        return LightEntryViewControllerTheme()
    }
}
