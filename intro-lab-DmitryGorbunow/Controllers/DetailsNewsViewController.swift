//
//  DetailsNewsViewController.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/4/23.
//

import UIKit

class DetailsNewsViewController: UIViewController {
    
    private lazy var dateSourseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var descr: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sourse: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Read more", for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(toWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(newsImage)
        view.addSubview(descr)
        view.addSubview(moreButton)
        view.addSubview(dateSourseStackView)
        dateSourseStackView.addArrangedSubview(date)
        dateSourseStackView.addArrangedSubview(sourse)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newsImage.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descr.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descr.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descr.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateSourseStackView.topAnchor.constraint(equalTo: descr.bottomAnchor, constant: 16),
            dateSourseStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateSourseStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            moreButton.topAnchor.constraint(equalTo: dateSourseStackView.bottomAnchor, constant: 32),
            moreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            moreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            moreButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    @objc private func toWebView() {
        guard let url = url else {
            return
        }

        let vc = WebKitViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    
    func setNewsWith(news: News) {
        guard let date = news.publishedAt?.convertIntoDate() else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = news.title
            self.descr.text = news.desc
            self.date.text = date.format("MMM. dd, yyyy")
            self.sourse.text = news.sourse
            if let url = news.url {
                self.url = url
            }
            if let url = news.urlToImage {
                self.newsImage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }

}
