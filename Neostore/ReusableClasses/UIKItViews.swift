//
//  ImagePagination.swift
//  Neostore
//
//  Created by Neosoft on 31/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct ImagePagination: UIViewRepresentable {

    var currentIndex:Int
    

    func makeUIView(context: UIViewRepresentableContext<ImagePagination>) -> UIPageControl {
        let page = UIPageControl()
        page.numberOfPages = 4
        page.currentPageIndicatorTintColor = UIColor.black
        page.pageIndicatorTintColor = .gray
        return page
    }

    func updateUIView(_ uiView: UIPageControl, context: UIViewRepresentableContext<ImagePagination>) {
        uiView.currentPage = currentIndex
    }
}
