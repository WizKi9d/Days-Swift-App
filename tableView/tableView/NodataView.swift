//
//  NodataView.swift
//  tableView
//
//  Created by Student on 31/01/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import SwiftUI

struct NodataView: View {
    var body: some View {
        VStack() {
            ScrollView {
                Image("noData")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .opacity(0.5)
                Text("Nothing to show!")
                    .bold()
                Text("Try adding some activites or tasks.")
            }.padding(.top, 80)
        }.frame(alignment: .top)
    }
}

struct NodataView_Previews: PreviewProvider {
    static var previews: some View {
        NodataView()
    }
}
