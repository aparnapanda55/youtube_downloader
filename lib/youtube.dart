class Video {
  final String title;
  final String author;
  final String duration;
  final String thumbnailUrl;
  final List<DownloadUrl> downloadUrls;

  Video({
    required this.title,
    required this.author,
    required this.duration,
    required this.thumbnailUrl,
    required this.downloadUrls,
  });
  @override
  String toString() {
    return '<Video $title ($author)>';
  }
}

class DownloadUrl {
  final String quality;
  final String size;
  final String url;
  DownloadUrl({
    required this.quality,
    required this.size,
    required this.url,
  });
}

Future<Video> getVideo(String videoId) {
  return Future<Video>.delayed(
    const Duration(seconds: 1),
    () => Video(
      title:
          'Packages and Plugins (The Boring Flutter Development Show, Ep. 6)',
      author: 'Google Developers',
      duration: '01:28:42',
      thumbnailUrl:
          'https://www.techsmith.com/blog/wp-content/uploads/2019/06/YouTube-Thumbnail-Sizes.png',
      downloadUrls: [
        DownloadUrl(
          quality: 'video/mp4 (360p)',
          size: '192 MB',
          url:
              'https://rr3---sn-cvh7knzd.googlevideo.com/videoplayback?expire=1641579366&ei=Bi_YYdHYJvKYmgfQoKlY&ip=3.110.191.245&id=o-AATA-VowzSWflkD1sWQpBCLXoxXDkjNpa56pu22UPKPY&itag=18&source=youtube&requiressl=yes&mh=ZT&mm=31%2C29&mn=sn-cvh7knzd%2Csn-cvh76ney&ms=au%2Crdu&mv=m&mvi=3&pl=14&initcwndbps=987500&vprv=1&mime=video%2Fmp4&ns=eHSHYGPGzB4-2BKPbD6TdTEG&gir=yes&clen=202593262&ratebypass=yes&dur=5322.129&lmt=1541438352076086&mt=1641557338&fvip=3&fexp=24001373%2C24007246&c=WEB&txp=5531432&n=UeNJleayYPx7bT&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIgXP_3r2IGvIISAIyAFyWlGW-CXPuFOyRIu05QKj9yUlkCIQCqKd632pgcT-ic7fL7ShEJiWgYODNTFBBZAqGSKVP9wg%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRgIhAL44tFXlEByOR04Pe5t3FoykOuRKtMs3QU7Z47WikefYAiEA_IZQnVkILaFkzVpJPGWOuLErsQuIIuFlIbCBrotySEI%3D',
        ),
        DownloadUrl(
          quality: 'video/webm (1080p)',
          size: '297 MB',
          url:
              "https://rr3---sn-cvh7knzd.googlevideo.com/videoplayback?expire=1641579366&ei=Bi_YYdHYJvKYmgfQoKlY&ip=3.110.191.245&id=o-AATA-VowzSWflkD1sWQpBCLXoxXDkjNpa56pu22UPKPY&itag=136&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278&source=youtube&requiressl=yes&mh=ZT&mm=31%2C29&mn=sn-cvh7knzd%2Csn-cvh76ney&ms=au%2Crdu&mv=m&mvi=3&pl=14&initcwndbps=987500&vprv=1&mime=video%2Fmp4&ns=O_2_6epdHwtGtW4irnC5ngoG&gir=yes&clen=170416366&dur=5322.066&lmt=1610429602523583&mt=1641557338&fvip=3&keepalive=yes&fexp=24001373%2C24007246&c=WEB&txp=5511222&n=U7vEkfJzbZx4an&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRAIgEggnfdqMPpy-PmgVfpNmruT13sQQEl6XoRLku8rAMVUCIEDjtZeHJOGSmbtn9iNnyoCbAuDo3-N4IvCOKYz7o8wZ&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRgIhAL44tFXlEByOR04Pe5t3FoykOuRKtMs3QU7Z47WikefYAiEA_IZQnVkILaFkzVpJPGWOuLErsQuIIuFlIbCBrotySEI%3D",
        )
      ],
    ),
  );
}
