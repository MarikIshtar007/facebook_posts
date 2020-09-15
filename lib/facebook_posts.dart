/// This package aims to get the data from Facebook Posts without accessing the
/// API of facebook.
/// Credits of this package go to ayob#4578 (discord).
///
/// This package also depends on two more packages. Namely the,
/// html and http packages.

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

/// The class Post defines the custom object used by the package to parse the
/// data obtained by the response fromt the website.

class FbPost {
  /// The title of the post is stored within the String variable named title
  String title;

  /// A list of strings to maintain the URL's of thumbnails of videos parsed
  /// from the given link of the facebook post;
  List<String> imagesUrl;

  FbPost({this.title, this.imagesUrl});
}

class FacebookPost {
  /// Main Helper function used to call the functionality of the package.
  Future getFbData(url) async {
    /// The url is parsed and passed to store and later aid in parsing the data obtained
    /// to acquire the title and the images.
    final response = await http.Client().get(Uri.parse(url));

    List<FbPost> posts = [];

    if (url.contains('facebook.com')) {
      // Check to see if the url is of facebook.com domain
      if (url.contains('posts')) {
        // Check to see if the url is of the proper format, including the posts word.
        try {
          if (response.statusCode == 200) {
            final document = parse(response.body);
            final length =
                document.getElementsByClassName('userContentWrapper').length;

            for (int i = 0; i <= length - 1; i++) {
              List<String> imageUrls = [];
              String title;
              final pinned = document
                  .getElementsByClassName('userContentWrapper')[i]
                  .children[0]
                  .children
                  .length;

              if (pinned != 4) {
                // To not show pinned publications
                try {
                  final images = document
                      .getElementsByClassName('userContentWrapper')[i]
                      .children[0]
                      .children[2]
                      .children[2]
                      .children[0]
                      .children[0]
                      .getElementsByTagName('img');
                  for (int index = 0; index <= images.length - 1; index++) {
                    String image = document
                        .getElementsByClassName('userContentWrapper')[i]
                        .children[0]
                        .children[2]
                        .children[2]
                        .children[0]
                        .children[0]
                        .getElementsByTagName('img')[index]
                        .outerHtml
                        .replaceAll('amp;', '')
                        .replaceAll(RegExp('.+[c][=]["]'), '')
                        .replaceAll(RegExp('["].+'), '');
                    imageUrls.add(image);
                  }
                  title = document
                      .getElementsByClassName('userContentWrapper')[i]
                      .getElementsByClassName('userContent')[0]
                      .text;
                } catch (e) {
                  imageUrls = [];
                  title = document
                      .getElementsByClassName('userContentWrapper')[i]
                      .getElementsByClassName('userContent')[0]
                      .text;
                }
              } else {
                imageUrls = null;
                title = null;
              }
              print('$i + $title + $imageUrls');
              if (imageUrls != null && title != null) {
                posts.add(FbPost(title: title, imagesUrl: imageUrls));
              }
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        print(
            'Check your URL format. Refer to the example.\nExample https://www.facebook.com/facebook/posts');
      }
    } else {
      print('The URL provided is not a valid facebook domain URL.');
    }
    return posts;
  }
}
