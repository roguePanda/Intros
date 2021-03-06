import Foundation

import RxSwift
import RxDataSources
import Action
import FontAwesome_swift
import Motif

protocol ImportInformationViewModelType {
    var socialImports: Observable<SocialImportSection> { get }
    
    func importItem(item: SocialImportItem) -> Observable<Void>
}

class ImportInformationViewModel: ImportInformationViewModelType {
    private let _socialImports: [SocialImportItem]
    private let user: User
    private let shareService: ShareServiceType
    
    init(user: User, shareService: ShareServiceType, theme: MTFTheme) {
        self.user = user
        self.shareService = shareService
        var items = [SocialImportItem]()
        
        if user.firstName != nil || user.lastName != nil || user.phoneNumber != nil {
            items.append(SocialImportItem(socialInfo: .Contact, icon: UIImage.fontAwesomeIconWithName(.UserPlus, textColor: theme.accentColor, size: CGSizeMake(100, 100), backgroundColor: UIColor.clearColor())))
        }
        
        if user.facebookId != nil {
            items.append(SocialImportItem(socialInfo: .Facebook, icon: UIImage(named: "fb-square")!))
        }
        
        if user.twitterHandle != nil {
            items.append(SocialImportItem(socialInfo: .Twitter, icon: UIImage(named: "twitter")!))
        }
        
        if user.snapchatUsername != nil {
            items.append(SocialImportItem(socialInfo: .Snapchat, icon: UIImage(named: "snap-ghost")!))
        }
        
        _socialImports = items
    }
    
    var socialImports: Observable<SocialImportSection> {
        return Observable.of(SocialImportSection(header: "Social Imports", socialImports: _socialImports))
    }
    
    func importItem(item: SocialImportItem) -> Observable<Void> {
        switch item.socialInfo {
        case .Contact:
            return shareService.shareContact(user)
        case .Facebook:
            shareService.shareFacebook(user)
            return Observable.just(())
        case .Twitter:
            shareService.shareTwitter(user)
            return Observable.just(())
        case .Snapchat:
            shareService.shareSnapchat(user)
            return Observable.just(())
        }
    }
}

enum SocialInfo: String {
    case Contact = "Contact"
    case Facebook = "Facebook"
    case Twitter = "Twitter"
    case Snapchat = "Snapchat"
}

extension SocialInfo: CustomDebugStringConvertible {
    var debugDescription: String {
        return self.rawValue
    }
}

struct SocialImportItem {
    let socialInfo: SocialInfo
    let icon: UIImage
}

extension SocialImportItem: IdentifiableType, Equatable {
    typealias Identity = SocialInfo
    
    var identity: SocialInfo {
        return socialInfo
    }
}

func == (lhs: SocialImportItem, rhs: SocialImportItem) -> Bool {
    return lhs.socialInfo == rhs.socialInfo
}

extension SocialImportItem: CustomDebugStringConvertible {
    var debugDescription: String {
        return "SocialImportItem(socialInfo: \(socialInfo.debugDescription), icon: \(icon.debugDescription))"
    }
}

struct SocialImportSection {
    var header: String
    var socialImports: [SocialImportItem]
    
    init(header: String, socialImports: [SocialImportItem]) {
        self.header = header
        self.socialImports = socialImports
    }
}

extension SocialImportSection: AnimatableSectionModelType {
    typealias Item = SocialImportItem
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    var items: [SocialImportItem] {
        return socialImports
    }
    
    init(original: SocialImportSection, items: [Item]) {
        self = original
        self.socialImports = items
    }
}

extension SocialImportSection: CustomDebugStringConvertible {
    var debugDescription: String {
        return "SocialImportSection(header: \(header.debugDescription), items: \(items.debugDescription))"
    }
}