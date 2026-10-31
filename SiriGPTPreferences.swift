import UIKit
import Preferences

@objc(SiriGPTPreferencesListController)
class SiriGPTPreferencesListController: PSListController {

    override var specifiers: NSMutableArray! {
        get {
            if _specifiers == nil {
                _specifiers = self.loadSpecifiers(fromPlistName: "Root", target: self)
            }
            return _specifiers
        }
        set {
            super.specifiers = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SiriGPT"
    }
}
