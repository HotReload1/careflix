import 'package:careflix/core/ui/waiting_widget.dart';
import 'package:careflix/layers/data/model/episode.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoStreamingScreen extends StatefulWidget {
  const VideoStreamingScreen({super.key, required this.episode});
  final Episode episode;

  @override
  State<VideoStreamingScreen> createState() => _VideoStreamingScreenState();
}

class _VideoStreamingScreenState extends State<VideoStreamingScreen> {
  WebViewController _webViewController = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    print(widget.episode.videoUrl);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.dataFromString(
          '<html><body style="margin:0;padding:0;"><iframe src="${widget.episode.videoUrl}" style="background-color:black;" height="100%" width="100%" frameborder="0" allowfullscreen="true"  ></iframe></body></html>',
          mimeType: 'text/html'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Center(
          child: Container(
              height: size.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black),
              child: Stack(
                children: [
                  WebViewWidget(controller: _webViewController),
                  isLoading
                      ? Center(
                          child: WaitingWidget(),
                        )
                      : SizedBox()
                ],
              )),
        ),
      ),
    );
  }
}
