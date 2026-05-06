import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController controller;
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    final String url = Get.arguments;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Print',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'close') {
            Get.back();
          }
        },
      )
      ..setBackgroundColor(const Color(0x00000000))

      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
            if (url.contains("success")) {
              // Start a 5-second timer to go back automatically
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted) {
                  Get.back();
                }
              });

              // Inject JS to handle "Close Window" button and window.close()
              controller.runJavaScript("""
                window.close = function() {
                  Print.postMessage('close');
                };
                
                function setupCloseButton() {
                  var buttons = document.querySelectorAll('button, a, input[type="button"]');
                  for (var i = 0; i < buttons.length; i++) {
                    if (buttons[i].innerText.toLowerCase().includes('close window') || 
                        (buttons[i].value && buttons[i].value.toLowerCase().includes('close window'))) {
                      buttons[i].onclick = function(e) {
                        e.preventDefault();
                        Print.postMessage('close');
                      };
                    }
                  }
                }
                setupCloseButton();
                // Re-run after a short delay in case of dynamic rendering
                setTimeout(setupCloseButton, 1000);
              """);
            }
          },

          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow success navigation to show the ToyyibPay success page
            if (request.url.contains("success")) {
              return NavigationDecision.navigate;
            }
            if (request.url.contains("fail")) {
              Get.back();
              // Show failure message
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          Obx(
            () => isLoading.value
                ? const Center(child: CustomLoader())
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
