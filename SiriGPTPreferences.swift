import UIKit
import Preferences

@objc(SiriGPTPreferencesListController)
class SiriGPTPreferencesListController: PSListController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SiriGPT"
    }

    override func specifiers() -> [Any]! {
        if _specifiers == nil {
            _specifiers = self.loadSpecifiers(fromPlistName: "Root", target: self)
        }
        return _specifiers
    }
}
