//
//  Observable.swift
//  WeatherApp
//
//  Created by dludlow7 on 05/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class Observable<T> {

    private var listener: ((T) -> ())?

    var value: T {
        didSet{
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ closure: @escaping (T) -> ()) {
        closure(value)
        listener = closure
    }

    func blah() {
        let stringy = Observable<String>("Blah")
        stringy.bind { string in
            print("Stringy updated to value: \"\(stringy)\"")
        }

        stringy.value = "Blah2"
        stringy.value = "Blah3"
    }
}
