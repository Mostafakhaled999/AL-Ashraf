import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:hive/hive.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String url;
  @HiveField(2)
  String? date;
  @HiveField(3)
  String? htmlContent;
  @HiveField(4)
  bool isFavourite;

  Post(
      {required this.url,
      this.title,
      this.date,
      this.htmlContent,
      this.isFavourite = false});

  void toggleFavourite() {
    isFavourite = !isFavourite;
  }
}

class PostData {
  List<Post> _favPosts = [];

  //String currentUrl = kMainPostUrl;
  Box? _box;

  get count {
    return _favPosts.length;
  }

  Post getPostByUrl(String url) {
    for (var post in _favPosts) {
      if (post.url == url) return post;
    }
    return Post(url: url);
  }

  Future<List<Post>> getFavouritePosts() async {
    _box = await Hive.openBox<Post>('FavouritePosts');
    _favPosts = _box!.values.toList().cast();
    return _favPosts;
  }

  Future<Post> updateFavouritePostStatus(Post post) async {
    var updatedPost = getPostByUrl(post.url);
    updatedPost.date = post.date ?? ' ';
    updatedPost.title = post.title ?? ' ';
    updatedPost.toggleFavourite();
    if (updatedPost.isFavourite) {
      await addtoFavourites(updatedPost);
    } else {
      await removeFromFavourites(updatedPost);
    }
    return updatedPost;
  }

  Future<void> removeFromFavourites(Post post) async {
    _box = await Hive.openBox<Post>('FavouritePosts');
    var postIndex = _favPosts.indexOf(post);
    try {
      await _box!.deleteAt(postIndex);
    } catch (e) {
      Get.showSnackbar(
          CustomWidgets.customSnackBar('تعذر حذف المقال من المقالات المفضلة'));
      return;
    }
    _favPosts.removeAt(postIndex);
    Get.showSnackbar(
        CustomWidgets.customSnackBar('تم حذف المقال من المقالات المفضلة'));
  }

  Future<void> addtoFavourites(Post post) async {
    _box = await Hive.openBox<Post>('FavouritePosts');
    try {
      await scrapContent(post);
      await _box!.add(post);
    } catch (e) {
      Get.showSnackbar(CustomWidgets.customSnackBar(
          'تعذر اضافة المقال الى المقالات المفضلة'));
      return;
    }
    _favPosts.add(post);
    Get.showSnackbar(
        CustomWidgets.customSnackBar('تمت اضافة المقال الى المقالات المفضلة'));
  }

  Future<void> scrapContent(Post post) async {
    var _webScraper = WebScraper(kMainPostUrl);
    await _webScraper.loadFullURL(post.url);
    final postContent = _webScraper.getPageContent();
    post.htmlContent = postContent;
  }
}
