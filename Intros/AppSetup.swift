import Foundation

import Swinject
import Motif
import Prephirences

class AppSetup {
    static var debug: Bool {
        if let debugValue = NSProcessInfo.processInfo().environment["DEBUG"] {
            return debugValue == "YES"
        }
        return false
    }
    
    static var test: Bool {
        return NSClassFromString("XCTest") != nil
    }
    
    static var devMode: Bool {
        return debug || test
    }
    
    static var simulator: Bool = {
        #if arch(i386) || arch(x86_64) && os(iOS)
            return true
        #else
            return false
        #endif
    }()
    
    // TODO: read-only prefs from file?
    // https://github.com/phimage/Prephirences#composing
    static let preferences: MutablePreferencesType = NSUserDefaults.standardUserDefaults()
    
    static var rootContainer = Container { container in
        container.register(UserManager.self) { _ in UserManagerImpl() }
        
        container.register(ShareServiceType.self) { _ in ShareService() }
        
        container.register(MutablePreferencesType.self) { _ in AppSetup.preferences }
        
        container.register(MTFTheme.self) { _ in
            do {
                return try MTFTheme(fromFilesNamed: ["Theme", "UserForm"])
            }
            catch let e {
                fatalError("Cannot load theme: \(e)")
            }
        }
    }
}