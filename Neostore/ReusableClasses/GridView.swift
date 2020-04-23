



import SwiftUI


struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content //return some sort of content we can show.

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(0 ..< rows) { row in
                HStack (spacing:20){
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
                
            }
        //.padding()
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}


struct CustomContainer: View {
    var body: some View {
       GridStack(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("Hello")
         
        }
    }
}

struct CustomContainer_Previews: PreviewProvider {
    static var previews: some View {
        CustomContainer()
    }
}

