import 'dart:core';
import 'package:coachandstudent/configer/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_html/html.dart' as html;

class LiveClassPage extends StatefulWidget {
  final String? roomId; // null if Coach starts a new class

  const LiveClassPage({super.key, this.roomId});

  @override
  State<LiveClassPage> createState() => _LiveClassPageState();
}

class _LiveClassPageState extends State<LiveClassPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  bool isCoach = false;
  String? activeRoomId;

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    _detectUserRole();
  }

  Future<void> _detectUserRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final role = doc.data()?["role"] ?? "student";
    setState(() => isCoach = role == "coach");

    if (isCoach) {
      await _createRoom();
    } else if (widget.roomId != null) {
      await _joinRoom(widget.roomId!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No room ID provided for student")),
      );
    }
  }

  Future<void> _createRoom() async {
    final config = {"iceServers": [{"urls": "stun:stun.l.google.com:19302"}]};
    _peerConnection = await createPeerConnection(config);

    _localStream =
    await navigator.mediaDevices.getUserMedia({"video": true, "audio": true});
    _localRenderer.srcObject = _localStream;
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    final roomRef = FirebaseFirestore.instance.collection("rooms").doc();
    activeRoomId = roomRef.id;

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await roomRef.set({"offer": offer.toMap()});

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        roomRef.collection("candidates").add(candidate.toMap());
      }
    };

    roomRef.snapshots().listen((snapshot) async {
      if (snapshot.data()?["answer"] != null) {
        final answer = RTCSessionDescription(
          snapshot.data()!["answer"]["sdp"],
          snapshot.data()!["answer"]["type"],
        );
        await _peerConnection!.setRemoteDescription(answer);
      }
    });

    roomRef.collection("candidates").snapshots().listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          final data = doc.doc.data()!;
          _peerConnection!.addCandidate(
            RTCIceCandidate(data["candidate"], data["sdpMid"], data["sdpMLineIndex"]),
          );
        }
      }
    });

    setState(() {});
  }

  Future<void> _joinRoom(String roomId) async {
    final config = {"iceServers": [{"urls": "stun:stun.l.google.com:19302"}]};
    _peerConnection = await createPeerConnection(config);

    _localStream =
    await navigator.mediaDevices.getUserMedia({"video": true, "audio": true});
    _localRenderer.srcObject = _localStream;
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    final roomRef = FirebaseFirestore.instance.collection("rooms").doc(roomId);
    activeRoomId = roomId;

    final roomSnapshot = await roomRef.get();
    if (!roomSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room not found")),
      );
      return;
    }

    final offer = roomSnapshot.data()!["offer"];
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(offer["sdp"], offer["type"]),
    );

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    await roomRef.update({"answer": answer.toMap()});

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        roomRef.collection("candidates").add(candidate.toMap());
      }
    };

    roomRef.collection("candidates").snapshots().listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          final data = doc.doc.data()!;
          _peerConnection!.addCandidate(
            RTCIceCandidate(data["candidate"], data["sdpMid"], data["sdpMLineIndex"]),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCoach ? "Coach Live Class" : "Student Live Class"),
        actions: [
          if (activeRoomId != null)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                // ✅ Copy Room ID differently for Web vs Mobile
                if (kIsWeb) {
                  html.window.navigator.clipboard?.writeText(activeRoomId!);
                } else {
                  Clipboard.setData(ClipboardData(text: activeRoomId!));
                }

                // ✅ Show feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Copied Room ID: $activeRoomId")),
                );
              },
            )
        ],
      ),
      body: SafeArea(
        child: Responsive(
          // ✅ Small Mobile
          smallMobile: Column(
            children: [
              Expanded(
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              if (isCoach) // 👈 Student won't see local video
                SizedBox(
                  height: 120,
                  child: RTCVideoView(_localRenderer, mirror: true),
                ),
            ],
          ),

          // ✅ Mobile
          mobile: Column(
            children: [
              Expanded(
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              if (isCoach)
                Container(
                  height: 160,
                  color: Colors.black87,
                  child: RTCVideoView(_localRenderer, mirror: true),
                ),
            ],
          ),

          // ✅ Tablet
          tablet: Row(
            children: [
              Expanded(
                flex: 3,
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              if (isCoach)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black87,
                    child: RTCVideoView(_localRenderer, mirror: true),
                  ),
                ),
            ],
          ),

          // ✅ Desktop
          desktop: Row(
            children: [
              Expanded(
                flex: isCoach ? 4 : 1, // full width for student
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              if (isCoach)
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: RTCVideoView(_localRenderer, mirror: true),
                        ),
                        if (activeRoomId != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(
                              "Room ID: $activeRoomId",
                              style: const TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

    );
  }
}
