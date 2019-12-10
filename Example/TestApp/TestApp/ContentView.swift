//
//  ContentView.swift
//  TestApp
//
//  Created by khoa on 21/08/2019.
//  Copyright © 2019 PumaSwift. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.locale) var locale: Locale

    var body: some View {
        VStack {
            Text(LocalizedStringKey("hello"))
                .font(.largeTitle)
            Text(flag(from: locale.regionCode!))
                .font(.largeTitle)
        }
    }

    private func flag(from country: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
