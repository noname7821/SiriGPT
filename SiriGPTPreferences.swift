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
    @AppStorage("SiriGPT_APIKey") var apiKey: String = ""
    @AppStorage("SiriGPT_Enabled") var isEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("OpenAI API Key")) {
                    SecureField("sk-...", text: $apiKey)
                    Text("Get one at platform.openai.com")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section {
                    Toggle("Enable SiriGPT", isOn: $isEnabled)
                }

                Section(header: Text("How it works")) {
                    Text("When Siri is active, your query is sent to ChatGPT and the answer is spoken back.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Section {
                    Button(action: {
                        apiKey = ""
                        isEnabled = false
                    }) {
                        Text("Reset Settings")
                            .foregroundColor(.red)
                    }
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
