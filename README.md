# facebook_posts

A Flutter Package that queries posts from a group to be used in your Flutter app. This is done without the aid of Facebook API, so no worrying of registration and limitations.

## Using

You can either wrap the method callback inside a future, to call the method. Or build up a custom Widget Tree to get the Posts.

The method **getFbData()** returns a list of **"FbPost"** Object. The Object has two properties, namely a title of the Post and a List of URL's of type String. It has the Pictures posted along with post.

```dart
// the FbPost Class for reference
class FbPost {

  String title;

  List<String> imagesUrl;

  FbPost({this.title, this.imagesUrl});
}
```

## Example

You can get the posts in an async method as shown below.

```dart

FacebookPost fbp = FacebookPost();
var myPost = [];
void getFbPosts() async {
    myPost = await fbp.getFbData('https://www.facebook.com/CBVpost/posts');
  }

```

The List so obtained could be shown as a ListView using ListTile as follows.

```dart
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
```
