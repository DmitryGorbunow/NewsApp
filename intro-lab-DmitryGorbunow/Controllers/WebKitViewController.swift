//
//  WebKitViewController.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/4/23.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController, WKUIDelegate {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()

    private let url: String

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.backgroundColor = .systemBackground
        guard let myURL = URL(string: url) else { return }
        let myRequest = URLRequest(url: myURL)
        self.webView.load(myRequest)

        configureButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapDone))

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefrash))
    }

    @objc private func didTapDone() {
        dismiss(animated: true)
    }

    @objc private func didTapRefrash() {
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)

        DispatchQueue.main.async {
            self.webView.load(myRequest)
        }
    }

}


