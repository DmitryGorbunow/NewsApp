//
//  NewsTableViewCell.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/3/23.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var viewsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(newsImage)
        addSubview(viewsImage)
        addSubview(viewsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            newsImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            newsImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            newsImage.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: viewsImage.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            viewsImage.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 2),
            viewsImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            
            viewsLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 2),
            viewsLabel.leadingAnchor.constraint(equalTo: viewsImage.trailingAnchor, constant: 3),
        ])
    }
    
    func setNewsCellWith(news: News) {
        DispatchQueue.main.async {
            self.titleLabel.text = news.title
            self.viewsLabel.text = String(DataManager.shared.getViews(url: news.url ?? ""))
            if let url = news.urlToImage {
                self.newsImage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
}
