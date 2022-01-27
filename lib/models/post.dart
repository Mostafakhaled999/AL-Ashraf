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
  List<Post> posts = [];
  //String currentUrl = kMainPostUrl;
  Box? _box ;

  get count{
    return posts.length;
  }

  Post getPostByUrl(String url) {
    for (var post in posts) {
      if (post.url == url) return post;
    }
    return Post(url: url);
  }

  Future<List<Post>> getFavouritePosts()async {
    _box = await Hive.openBox<Post>('FavouritePosts');
    posts = _box!.values.toList().cast();
    return posts;
  }

  Future<void> updatePostFavouriteStatus(String postUrl) async {
    var post = getPostByUrl(postUrl);
    post.toggleFavourite();
    if (post.isFavourite) {
      await addtoFavourites(post);
    } else {
      await removeFromFavourites(post);
    }
  }

  Future<void> removeFromFavourites(Post post) async {
    _box = await Hive.openBox<Post>('FavouritePosts');
    var postIndex = posts.indexOf(post);
    try {
      await _box!.deleteAt(postIndex);
    } catch (e) {
      Get.showSnackbar(CustomWidgets.customSnackBar('تعذر حذف المقال من المقالات المفضلة'));
    }
    posts.removeAt(postIndex);
    Get.showSnackbar(CustomWidgets.customSnackBar('تم حذف المقال من المقالات المفضلة'));
  }

  Future<void> addtoFavourites(Post post) async {
    _box = await Hive.openBox<Post>('FavouritePosts');
    try {
      await scrapContent(post);
      await _box!.add(post);
    } catch (e) {
      Get.showSnackbar(CustomWidgets.customSnackBar('تعذر اضافة المقال الى المقالات المفضلة')) ;
    }
    posts.add(post);
    Get.showSnackbar(CustomWidgets.customSnackBar('تمت اضافة المقال الى المقالات المفضلة')) ;
  }

  Future<void> scrapContent(Post post) async {

    var _webScraper =  WebScraper(kMainPostUrl);
    await _webScraper.loadFullURL(post.url);
    final postContent =  _webScraper.getPageContent();
    List<String> postTitle;
     postTitle = _webScraper
        .getElementTitle('header.entry-header > h1.entry-title');
     if(postTitle.isEmpty){
       postTitle = _webScraper
           .getElementTitle('header.entry-header > h3.entry-title');
         if(postTitle.isEmpty){
           return Future.error('error');
         }
     }
    final postDate = _webScraper.getElementTitle(
        'header.entry-header > div.entry-meta > span.posted-on > a > time.entry-date.published');
    post.htmlContent = postContent;
    post.title = postTitle.first;
    post.date = postDate.first;
  }
}
