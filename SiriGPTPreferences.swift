import UIKit
import SwiftUI
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

struct SiriGPTRootView: View {
    @AppStorage("SiriGPT_Enabled") var isEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable SiriGPT", isOn: $isEnabled)
                }

                Section(header: Text("How it works")) {
                    Text("When Siri is active, your query is sent to the ChatGPT app on your iPhone and the answer is spoken back. No API key needed.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Requirements")) {
                    Text("Install the ChatGPT app from the App Store before enabling.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("SiriGPT")
        }
    }
}

@objc(SiriGPTPreferencesSwiftUIViewController)
class SiriGPTPreferencesSwiftUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let hosting = UIHostingController(rootView: SiriGPTRootView())
        addChild(hosting)
        hosting.view.frame = view.bounds
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
    }
}
