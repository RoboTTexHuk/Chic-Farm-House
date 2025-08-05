import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter InAppWebView Loader Demo',
      home: const WebViewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoading = true;
  bool _showText = true;
  Timer? _timer;
  String? _htmlData;

  @override
  void initState() {
    super.initState();
//    _loadHtmlFromAssets();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _showText = !_showText;
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });

  }

  Future<void> _loadHtmlFromAssets() async {
    String fileHtml = await rootBundle.loadString('assets/my_page.html');
    setState(() {
      _htmlData = fileHtml;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

            InAppWebView(
              initialFile: 'assets/index.html',
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                supportZoom: false, // Отключает pinch-to-zoom и double-tap zoom
                disableHorizontalScroll: false,
                disableVerticalScroll: false,

                disableDefaultErrorPage: true,

                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                allowsPictureInPictureMediaPlayback: true,
                useOnDownloadStart: true,
                javaScriptCanOpenWindowsAutomatically: true,
                useHybridComposition: true, // Улучшает производительность на iOS

                transparentBackground: true, // Если нужно
                disableContextMenu: true, // Отключает контекстное меню, чтобы избежать toolbar конфликтов
              ),
              onLoadStop: (controller, url) async {
                setState(() {
                  _isLoading = false;
                });
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  _isLoading = false;
                });
              },
              onLoadHttpError: (controller, url, statusCode, description) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          if (_isLoading)
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.yellow,
                alignment: Alignment.center,
                child: _showText
                    ? const Text(
                  'birds ferm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}