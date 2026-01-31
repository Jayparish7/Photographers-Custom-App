import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_flutter/core/constants/api_urls_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

String getPublicUrlForGallery(String albumId, String imageName) {
  return "$storageUrl$studioId/$albumId/images/original/others/$imageName";
}

Future<String> getVideoCoverImage(String videoId) async {
  List<String> qualityLevels = [
    'maxresdefault',
    'sddefault',
    'hqdefault',
    'mqdefault',
    'default'
  ];
  if (videoId.contains("vimeo")) {
    return await getVimeoThumbnail(videoId);
  }
  if (videoId.contains("odysee")) {
    return await getOdyseeThumbnail(videoId) ?? '';
  }

  for (String quality in qualityLevels) {
    final url =
        "https://img.youtube.com/vi/${videoId.split("/").last}/$quality.jpg";
    final response = await http.get(Uri.parse(url));
    showLog('url $url--- ${response.statusCode}');
    if (response.statusCode == 200) {
      return url;
    }
  }

  // Fallback to a lower quality image or an error image if all attempts fail
  return "https://img.youtube.com/vi/$videoId/0.jpg";
}

Future<String> getVimeoThumbnail(String videoId) async {
  final url =
      'https://vimeo.com/api/oembed.json?url=https://vimeo.com/${videoId.split("/").last}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['thumbnail_url'];
  } else {
    print('Failed to load thumbnail');
    return '';
  }
}

Future<String?> getOdyseeThumbnail(String videoUrl) async {
  try {
    final response = await http.get(Uri.parse(videoUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final metaTags = document.getElementsByTagName('meta');
      final thumbnailMeta = metaTags.firstWhere(
        (meta) => meta.attributes['property'] == 'og:image',
        //orElse: () => null,
      );
      if (thumbnailMeta != null) {
        return thumbnailMeta.attributes['content'];
      }
    }
  } catch (e) {
    print('Error fetching thumbnail: $e');
  }
  return null;
}

/*isYouTubeVideoAvailable(String videoId) async {
  try {
    final response =
        await http.get(Uri.parse('https://img.youtube.com/vi/$videoId/0.jpg'));
    showLog('isYouTubeVideoAvailable${response.statusCode}');
    if (response != null) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    // An error occurred (e.g., network issues)
    print('Error checking YouTube video availability: $e');
    return false;
  }
}*/

class DownloadImage {
  String? imageUrl;
  String? imageName;
  int? imageId;

  //int accessType;
  DownloadImage({this.imageUrl, this.imageName, this.imageId});
}

String getImageWithExtension(String imageName) {
  String extension = getImageExtension(imageName);
  if (!imageName.endsWith(extension)) {
    imageName = imageName + getImageExtension(imageName);
  }
  return imageName;
}

String getImageExtension(String imageName) {
  showLog('');
  var extension =
      imageName.substring(imageName.lastIndexOf(".") + 1, imageName.length);
  var imageExtension;
  if (extension.endsWith("jpg") || extension.endsWith("jpeg")) {
    imageExtension = ".jpeg";
  } else if (extension.endsWith("png")) {
    imageExtension = ".png";
  } else if (extension.endsWith("webp")) {
    imageExtension = ".webp";
  } else {
    imageExtension = ".jpg";
  }
  return imageExtension;
}

//image type 0->event, 1->completed album, 2->photo selection, 3->invitation, 4->profile

deleteImage(String imageNameWithExtension) async {
  showLog("Inside locale image function");
  showLog("Image name : $imageNameWithExtension");
  var documentDirectory = await getApplicationDocumentsDirectory();

  var checkFile =
      await File('${documentDirectory.path}/$imageNameWithExtension').exists();
  showLog(
      "File name with path -> ${documentDirectory.path}/$imageNameWithExtension");
  if (checkFile) {
    showLog("true");
    await File('${documentDirectory.path}/$imageNameWithExtension').delete();
  } else {
    showLog("false");
  }
  //checkFile==true?await File('${documentDirectory.path}/$imageNameWithExtension').delete():"";
}
