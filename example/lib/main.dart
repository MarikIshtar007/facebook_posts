import 'package:flutter/material.dart';
import 'package:facebook_posts/facebook_posts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FacebookPost fbp = FacebookPost();
  var myPost = [];
  @override
  void initState() {
    super.initState();
  }

  void getFbPosts() async {
    myPost = await fbp.getFbData('https://www.facebook.com/CBVpost/posts');
  }

  Widget myWidget = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: RaisedButton(
                child: Text('Press to get Post Data'),
                onPressed: () async {
                  await getFbPosts();
                  setState(() {
                    myWidget = myList(myPost);
                  });
                },
              ),
            ),
          ),
          Expanded(flex: 1, child: myWidget)
        ],
      ),
    ));
  }
}

Widget myList(var theList) {
  return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            thickness: 1,
          ),
      shrinkWrap: true,
      itemCount: theList.length,
      itemBuilder: (context, index) {
        print(theList[index].imagesUrl);
        var data = theList[index];
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Color(0xFFF0F0F0),
              child: ListTile(
                title: Text(data.title),
                subtitle: SizedBox(
                  height: 120,
                  width: 300,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => VerticalDivider(
                      thickness: 1,
                    ),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data.imagesUrl.length,
                    itemBuilder: (context, index) =>
                        Image.network(data.imagesUrl[index]),
                  ),
                ),
              ),
            ));
      });
}
