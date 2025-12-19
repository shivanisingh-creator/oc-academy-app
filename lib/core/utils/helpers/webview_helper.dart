import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oc_academy_app/core/utils/storage.dart';

class WebViewHelper {
  final TokenStorage _tokenStorage = TokenStorage();

  /// Initializes a WebViewController with default settings and optional token injection.
  ///
  /// If [autoInjectTokens] is true, it will fetch tokens from [TokenStorage]
  /// and inject them into localStorage/cookies on every page load.
  Future<WebViewController> createController({
    required String initialUrl,
    bool autoInjectTokens = true,
    Function(int)? onProgress,
    Function(String)? onPageStarted,
    Function(String)? onPageFinished,
    Function(WebResourceError)? onWebResourceError,
  }) async {
    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: onProgress,
          onPageStarted: onPageStarted,
          onPageFinished: (url) async {
            if (autoInjectTokens) {
              await injectAuthTokens(controller);
            }
            if (onPageFinished != null) onPageFinished(url);
          },
          onWebResourceError: onWebResourceError,
        ),
      );

    await controller.loadRequest(Uri.parse(initialUrl));
    return controller;
  }

  /// Manually injects authentication tokens into the WebView.
  Future<void> injectAuthTokens(WebViewController controller) async {
    final String? accessToken = await _tokenStorage.getAccessToken();
    final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

    String js = "";
    if (accessToken != null) {
      js += "localStorage.setItem('access_token', '$accessToken');";
      js += "document.cookie = 'access_token=$accessToken; path=/';";
    }
    if (hkAccessToken != null) {
      js += "localStorage.setItem('hk_access_token', '$hkAccessToken');";
      js += "document.cookie = 'hk_access_token=$hkAccessToken; path=/';";
    }

    if (js.isNotEmpty) {
      await controller.runJavaScript("(function(){$js})();");
    }
  }

  /// High-level method to load a URL with tokens.
  Future<void> loadUrlWithAuth(WebViewController controller, String url) async {
    await controller.loadRequest(Uri.parse(url));
    // Tokens will be injected by the NavigationDelegate defined in createController
  }
}

// Global instance helper if needed
final webViewHelper = WebViewHelper();
