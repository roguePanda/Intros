import Foundation
import UIKit

import Swinject
import Motif

final class EditUserPage: Page {
    static var container = Container(parent: AppSetup.rootContainer) { container in
        container.registerForStoryboard(UserFormViewController.self) { r, c in
            c.userManager = r.resolve(UserManager.self)!
            c.theme = r.resolve(MTFTheme.self)
        }
    }
    
    static var storyboard: SwinjectStoryboard {
        return SwinjectStoryboard.create(name: "EditUser", bundle: nil, container: container)
    }
    
    func createViewController() -> UIViewController {
        return EditUserPage.storyboard.instantiateInitialViewController()!
    }
}