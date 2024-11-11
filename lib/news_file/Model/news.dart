class News {
  final int shopId;
  final int newsId;
  //final String categorie;
  //final City city;
  final DateTime createdAt;
  final String titleNews;
  final String content;
  final String imageUrl;
  final String titleShop;

  News({
    this.newsId,
    this.shopId,
    this.createdAt,
    this.titleNews,
    this.content,
    this.imageUrl,
    this.titleShop,
  });
}
