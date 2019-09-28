///
/// Created by NieBin on 2019/9/28
/// Github: https://github.com/nb312
/// Email: niebin312@gmail.com
import "package:flutter/material.dart";
import 'package:http2/http2.dart';
import 'dart:io';
import 'dart:convert';

class Http2Page extends StatefulWidget {
  @override
  _Http2PageState createState() => _Http2PageState();
}

class _Http2PageState extends State<Http2Page> {
  void _http2Test() async {
    print("http");
    var uri = Uri.parse("https://www.mocky.io/v2/5185415ba171ea3a00704eed");
    var client = ClientTransportConnection.viaSocket(
      await SecureSocket.connect(
        uri.host,
        uri.port,
        supportedProtocols: ["h2"],
      ),
    );
    var stream = client.makeRequest([
      Header.ascii(":method", "get"),
      Header.ascii(":path", uri.path),
      Header.ascii(":scheme", uri.scheme),
      Header.ascii(":authority", uri.host),
    ], endStream: true);
    await for (var message in stream.incomingMessages) {
      if (message is HeadersStreamMessage) {
        for (var header in message.headers) {
          var name = utf8.decode(header.name);
          var value = utf8.decode(header.value);
          print("name = $name, value = $value");
        }
      } else if (message is DataStreamMessage) {
        print("data: ${utf8.decode(message.bytes)}");
      }
    }
    await client.finish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Http2"),
      ),
      body: Container(
        child: Center(
          child: Text("http2 测试"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _http2Test,
        child: Icon(Icons.border_clear),
      ),
    );
  }
}
