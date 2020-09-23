class ImageData {
  String imageUrl;
  String imagePath;

  ImageData({this.imageUrl, this.imagePath});

  ImageData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['image_path'] = this.imagePath;
    return data;
  }
}