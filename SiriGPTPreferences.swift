import UIKit
import Preferences

@objc(SiriGPTPreferencesListController)
class SiriGPTPreferencesListController: PSListController {

    override var specifiers: NSMutableArray! {
        get {
            if super.specifiers == nil {
                super.specifiers = NSMutableArray(array: self.loadSpecifiers(fromPlistName: "Root", target: self) ?? [])
            }
            return super.specifiers
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
